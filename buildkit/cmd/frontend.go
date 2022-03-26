package cmd

import (
	"context"

	"buildkit-gosh/pkg/constants"

	"github.com/moby/buildkit/client/llb"
	"github.com/moby/buildkit/frontend/dockerfile/dockerfile2llb"
	"github.com/moby/buildkit/frontend/gateway/client"
	"github.com/moby/buildkit/frontend/gateway/grpcclient"
	"github.com/moby/buildkit/util/appcontext"
	"github.com/pkg/errors"
	"github.com/spf13/cobra"
)

func frontendCmd() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "frontend",
		Short: "Frontend entrypoint",
		Args:  cobra.NoArgs,
		RunE:  frontend,
	}
	return cmd
}

const (
	localConfigMount = "dockerfile"
	keyFilename      = "filename"
	sharedKeyHint    = constants.DefaultConfigFile
)

func frontend(cmd *cobra.Command, args []string) error {
	p("start logging")
	return grpcclient.RunFromEnvironment(appcontext.Context(), frontendBuild("bash"))
}

// docker-gosh.yaml by default
func loadConfig(ctx context.Context, c client.Client) (*Config, error) {
	filename := c.BuildOpts().Opts[keyFilename]
	logf("[docker-gosh frontend/loadConfig] filename %v", filename)
	if filename == "" {
		filename = constants.DefaultConfigFile
	}

	name := "load config"
	if filename != constants.DefaultConfigFile {
		name += " from " + filename
	}

	configState := llb.Local(
		localConfigMount,
		llb.SessionID(c.BuildOpts().SessionID),
		llb.SharedKeyHint(sharedKeyHint), // don't know
		llb.WithCustomName("[docker-gosh frontend/loadConfig] "+name),
	)

	definition, err := configState.Marshal(ctx)
	if err != nil {
		return nil, errors.Wrapf(err, "failed to marshal local source")
	}

	var configFile []byte
	result, err := c.Solve(ctx, client.SolveRequest{
		Definition: definition.ToPB(),
	})
	if err != nil {
		return nil, errors.Wrapf(err, "failed to resolve image config")
	}

	ref, err := result.SingleRef()
	if err != nil {
		return nil, err
	}

	configFile, err = ref.ReadFile(ctx, client.ReadRequest{
		Filename: filename,
	})
	if err != nil {
		return nil, errors.Wrapf(err, "failed to read image config "+filename)
	}

	return parseConfig(configFile)
}

func frontendBuild(imageName string) client.BuildFunc {
	return func(ctx context.Context, c client.Client) (*client.Result, error) {

		logf("[docker-gosh frontend/build] start build image %v", imageName)

		logf("[docker-gosh frontend/build] [wallet opt] %v", c.BuildOpts().Opts["wallet"])

		// load config
		config, err := loadConfig(ctx, c)
		if err != nil {
			return nil, err
		}
		logf("[docker-gosh frontend/build] config: %v", config)

		// init image
		goshImage := llb.Image(
			imageName,
			llb.WithMetaResolver(c),
			dockerfile2llb.WithInternalName("test gosh"),
			llb.WithCustomName("[docker-gosh frontend/build] init test gosh image"),
		)
		// _ = goshImage

		for _, step := range config.Steps {
			logf("[docker-gosh frontend/build] step: %#v", step)
			if step.Run != nil {
				runOptions := []llb.RunOption{
					llb.IgnoreCache,
					llb.WithCustomName("[docker-gosh frontend/build] " + step.Name),
				}
				runOptions = append(runOptions,
					llb.Args(append(step.Run.Command, step.Run.Args...)),
				)
				runSt := goshImage.Run(
					runOptions...,
				)
				logf("[docker-gosh frontend/build] run: %#v", runOptions)
				// _ = runSt
				goshImage = runSt.Root()
				continue
			}
		}

		def, err := goshImage.Marshal(ctx)
		if err != nil {
			return nil, err
		}

		res, err := c.Solve(ctx, client.SolveRequest{
			Definition: def.ToPB(),
		})
		if err != nil {
			return nil, errors.Wrapf(err, "failed to resolve dockerfile")
		}
		ref, err := res.SingleRef()
		if err != nil {
			return nil, err
		}

		res.SetRef(ref)

		return res, nil
	}
}

// func getSelfImageSt(ctx context.Context, c client.Client, localDfSt llb.State, dfName string) (*llb.State, string, error) {
// 	localDfDef, err := localDfSt.Marshal(ctx)
// 	if err != nil {
// 		return nil, "", err
// 	}
// 	localDfRes, err := c.Solve(ctx, client.SolveRequest{
// 		Definition: localDfDef.ToPB(),
// 	})
// 	if err != nil {
// 		return nil, "", err
// 	}
// 	localDfRef, err := localDfRes.SingleRef()
// 	if err != nil {
// 		return nil, "", err
// 	}
// 	dfBytes, err := localDfRef.ReadFile(ctx, client.ReadRequest{Filename: dfName})
// 	if err != nil {
// 		return nil, "", err
// 	}
// 	selfImageRefStr, _, _, ok := dockerfile2llb.DetectSyntax(bytes.NewReader(dfBytes))
// 	if !ok {
// 		return nil, "", fmt.Errorf("failed to detect self image reference from %q", dfName)
// 	}
// 	if selfImageDgst, _, err := c.ResolveImageConfig(ctx, selfImageRefStr, llb.ResolveImageConfigOpt{}); err != nil {
// 		return nil, "", err
// 	} else if selfImageDgst != "" {
// 		selfImageRef, err := reference.ParseNormalizedNamed(selfImageRefStr)
// 		if err != nil {
// 			return nil, "", err
// 		}
// 		selfImageRefWithDigest, err := reference.WithDigest(selfImageRef, selfImageDgst)
// 		if err != nil {
// 			return nil, "", err
// 		}
// 		selfImageRefStr = selfImageRefWithDigest.String()
// 	}
// 	selfImageSt := llb.Image(selfImageRefStr, llb.WithMetaResolver(c), dockerfile2llb.WithInternalName("self image"))
// 	return &selfImageSt, selfImageRefStr, nil
// }

// func validateSelfImageSt(ctx context.Context, c client.Client, selfImageSt llb.State, selfImageRefStr string) (string, error) {
// 	selfPath, err := os.Executable()
// 	if err != nil {
// 		return "", err
// 	}
// 	selfR, err := os.Open(selfPath)
// 	if err != nil {
// 		return "", err
// 	}
// 	selfStat, err := selfR.Stat()
// 	if err != nil {
// 		selfR.Close()
// 		return "", err
// 	}
// 	selfSize := selfStat.Size()
// 	selfDigest, err := digest.Canonical.FromReader(selfR)
// 	if err != nil {
// 		selfR.Close()
// 		return "", err
// 	}
// 	if err = selfR.Close(); err != nil {
// 		return "", err
// 	}

// 	def, err := selfImageSt.Marshal(ctx)
// 	if err != nil {
// 		return "", err
// 	}
// 	res, err := c.Solve(ctx, client.SolveRequest{
// 		Definition: def.ToPB(),
// 	})
// 	if err != nil {
// 		return "", err
// 	}
// 	ref, err := res.SingleRef()
// 	if err != nil {
// 		return "", err
// 	}

// 	selfStat2, err := ref.StatFile(ctx, client.StatRequest{Path: selfPath})
// 	if err != nil {
// 		return "", err
// 	}
// 	selfSize2 := selfStat2.Size_
// 	if int64(selfSize2) != selfSize {
// 		return "", fmt.Errorf("expected the size of %q in the image %q to be %d, got %d [Hint: set sha256 explicitly in the `# syntax = IMAGE:TAG@sha256:SHA256` line]",
// 			selfPath, selfImageRefStr, selfSize, selfSize2)
// 	}

// 	selfR2, err := refutil.NewRefFileReader(ctx, ref, selfPath)
// 	if err != nil {
// 		return "", err
// 	}
// 	selfDigest2, err := digest.Canonical.FromReader(selfR2)
// 	if err != nil {
// 		return "", err
// 	}

// 	if selfDigest2.String() != selfDigest.String() {
// 		return "", fmt.Errorf("expected the digest of %q in the image %q to be %s, got %s [Hint: set sha256 explicitly in the `# syntax = IMAGE:TAG@sha256:SHA256` line]",
// 			selfPath, selfImageRefStr, selfDigest, selfDigest2)
// 	}
// 	return selfPath, nil
// }
