Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14CF573FB55
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Jun 2023 13:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbjF0LsJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Jun 2023 07:48:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjF0LsH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 27 Jun 2023 07:48:07 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA305F4
        for <ceph-devel@vger.kernel.org>; Tue, 27 Jun 2023 04:48:06 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-9924ac01f98so6929766b.1
        for <ceph-devel@vger.kernel.org>; Tue, 27 Jun 2023 04:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687866485; x=1690458485;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sWRBSaZODTZw5qaPcpl1M+d5NMb5GB2VjcmpUBLZkH4=;
        b=cqzekp82B9t/tv94nOZZRlyPm2+sKRPIUl9uM9SnMZtqlNUNkiXn6/QOYZA3xwAFKq
         ekw8dJy+VEXW8CSJ8DwXsDftLUr5JnFcVBu404Ihfw8ovsA+lGDvQa7Yn7c2P5hGw6j9
         s9Dgp+ThWHVKyD4YkEwMeVMPRJKj0Cjb50RDVdW+oHH0KPgowEyFsbY8iLz+RxkTzRNv
         IO4q4cnu9gmqqSoVQWMoohUbHAUdHO9AvcJQnHT8nF6pS0NQ/OpJNvYkg3PMoF0vxpRo
         7u5wKUTQN1NlcHYWdZcQ2V+aNpvmvwk7Rp7B2YxA8v+R+5+sYQueHvfLYthK9lS1p7ul
         71tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687866485; x=1690458485;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sWRBSaZODTZw5qaPcpl1M+d5NMb5GB2VjcmpUBLZkH4=;
        b=F1dPPer/rvuOLCgR+BYzcq00n2HksYJ2tnu/TjQeqSTmG9skw5EpSSwqnnNpvd6O61
         YWtOzyyp5D/kHi2KTr8zK7DIlwjxMt6REss5FdkClbGHwsvquQt5beFlNkH5k/x1dPN0
         gkHmaZCHu3dWFckDvFG/aiNcdjDN8++cRAYsPGdbNW4tGch49BkTIPiRBEYG+PQE4WN0
         BqLbjbAzw0dX/Ja4MwHkwPW2jg7//Y/yafrf6u9qeR+fuwdU7BxVb/6Uku+ZSV/4fobf
         T19N2dMES5blN2kdo80vXjiXl2bwF6sTb3ovbGY2QV7NO1NQ7OnHWqQ92f8/ZCmnA87N
         wW9A==
X-Gm-Message-State: AC+VfDzYDpwulO3fwNnyNWMGPesP58xvm0+ELW45iSTdPlvTsBFT5R2t
        apk8MXAsK0XAfxPKu552hM4ZVbCSCdoX5yMLkXCGvVNiWGQ=
X-Google-Smtp-Source: ACHHUZ7D5ZAqw/5B6lz6B+C0njSwztawsXo8E4kdcbfU5ydnDxjF0aI4K6lk5wNXCFnz+Gtu0BPPibESBDFMCXYu8ZQ=
X-Received: by 2002:a17:906:6a07:b0:989:ca:a0a2 with SMTP id
 qw7-20020a1709066a0700b0098900caa0a2mr21773255ejc.69.1687866485055; Tue, 27
 Jun 2023 04:48:05 -0700 (PDT)
MIME-Version: 1.0
References: <TYCP286MB20661F87B0C796738BDC5FBEC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
 <TYCP286MB2066D19A68A9176E289BB4FDC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
In-Reply-To: <TYCP286MB2066D19A68A9176E289BB4FDC0709@TYCP286MB2066.JPNP286.PROD.OUTLOOK.COM>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 27 Jun 2023 13:47:53 +0200
Message-ID: <CAOi1vP_zuTMh2jE9uc89EfTroxkY1YBfOPCMBreKNtDMXa2nRQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] libceph: reject mismatching name and fsid
To:     Hu Weiwen <huww98@outlook.com>
Cc:     ceph-devel@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Venky Shankar <vshankar@redhat.com>,
        Hu Weiwen <sehuww@mail.scut.edu.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sun, May 7, 2023 at 7:56=E2=80=AFPM Hu Weiwen <huww98@outlook.com> wrote=
:
>
> From: Hu Weiwen <sehuww@mail.scut.edu.cn>
>
> These are present in the device spec of cephfs. So they should be
> treated as immutable.  Also reject `mount()' calls where options and
> device spec are inconsistent.
>
> Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
> ---
>  net/ceph/ceph_common.c | 26 +++++++++++++++++++++-----
>  1 file changed, 21 insertions(+), 5 deletions(-)
>
> diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> index 4c6441536d55..c59c5ccc23a8 100644
> --- a/net/ceph/ceph_common.c
> +++ b/net/ceph/ceph_common.c
> @@ -440,17 +440,33 @@ int ceph_parse_param(struct fs_parameter *param, st=
ruct ceph_options *opt,
>                 break;
>
>         case Opt_fsid:
> -               err =3D ceph_parse_fsid(param->string, &opt->fsid);
> +       {
> +               struct ceph_fsid fsid;
> +
> +               err =3D ceph_parse_fsid(param->string, &fsid);
>                 if (err) {
>                         error_plog(&log, "Failed to parse fsid: %d", err)=
;
>                         return err;
>                 }
> -               opt->flags |=3D CEPH_OPT_FSID;
> +
> +               if (!(opt->flags & CEPH_OPT_FSID)) {
> +                       opt->fsid =3D fsid;
> +                       opt->flags |=3D CEPH_OPT_FSID;
> +               } else if (ceph_fsid_compare(&opt->fsid, &fsid)) {
> +                       error_plog(&log, "fsid already set to %pU",
> +                                  &opt->fsid);
> +                       return -EINVAL;
> +               }
>                 break;
> +       }
>         case Opt_name:
> -               kfree(opt->name);
> -               opt->name =3D param->string;
> -               param->string =3D NULL;
> +               if (!opt->name) {
> +                       opt->name =3D param->string;
> +                       param->string =3D NULL;
> +               } else if (strcmp(opt->name, param->string)) {
> +                       error_plog(&log, "name already set to %s", opt->n=
ame);
> +                       return -EINVAL;
> +               }
>                 break;
>         case Opt_secret:
>                 ceph_crypto_key_destroy(opt->key);
> --
> 2.25.1
>

Hi Hu,

I'm not following the reason for singling out "fsid" and "name" in
ceph_parse_param() in net/ceph.  All options are overridable in the
sense that the last setting wins on purpose, this is a long-standing
behavior.  Allowing "key" or "secret" to be overridden while rejecting
the corresponding override for "name" is weird.

If there is a desire to treat "fsid" and "name" specially in CephFS
because they are coming from the device spec and aren't considered to
be mount options in the usual sense, I would suggest enforcing this
behavior in fs/ceph (and only when the device spec syntax is used).

Thanks,

                Ilya
