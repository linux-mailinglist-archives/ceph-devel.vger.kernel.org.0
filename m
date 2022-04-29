Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A29245140B3
	for <lists+ceph-devel@lfdr.de>; Fri, 29 Apr 2022 04:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234636AbiD2CuG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Apr 2022 22:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234645AbiD2CuB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 28 Apr 2022 22:50:01 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B9C2C654
        for <ceph-devel@vger.kernel.org>; Thu, 28 Apr 2022 19:46:44 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id u9so5356232plf.6
        for <ceph-devel@vger.kernel.org>; Thu, 28 Apr 2022 19:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3+IsKcj2nCw7mJbAEKsppYkUKuKinwAZhwBKpwdQeZk=;
        b=PC93DNUcaJ33ByLr8GO7+lZHS0DJkLAVr+xapqe8ttN60oFe/0of1SdnlYQ6tI3zMp
         igLc6zcGApAf78h5zqX9XuA6eoqw/1FtlX+y4INIm5/eAGgqUJXXJbGvXoGh6pe1kamL
         DjU/Bpkk9+bOjPec0odR5Ed+a04U7RB99zRZPATGsGdmADbi97YwK/a+Sut7edfuNNAU
         jb9oxAPPvPnGIb19e0uX+5Pw9bRJQimV4oHrVaFoiD5ExGnnuSrjzxLBzXMC9xlaqC+E
         Ui32pM6j8Ki3YXOSS9Ln/hoO8Ydo1CJeuOChElQM4dJ/2d+hiMtnXuUB1r0DqZvEavuI
         JGyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3+IsKcj2nCw7mJbAEKsppYkUKuKinwAZhwBKpwdQeZk=;
        b=W7uByq42fw5DYE6EP84PKqIZ4eEJDvydfjp/zYgaVr0x2rRwX9F9LolpTDO6C3nSYs
         aeFBCWkEtJtFtMaUIdwohUTV1lm3nO1SxMeLK7Pjo3bVWuXftJoKm6TAZEtna0glTOqK
         mzKUlZ5ZwYnwyqbDmeiOtz1A1vdWsbEVQ/OgQXdTfFjqtO6rz7Xz06IhQ+ri1JV9FAdS
         doQNDjVmcBeFrqZlTKZFs7zeYwu/OLiY5ijPcqjj7BJdEQ5oTWynjLMmJWpbnBB5G9ff
         91uDaBtu/0zi4hS52tVlFmghYOy6jrvc8mJIp4poUCTfrQrDqJrd091Bdb6TJ8p0t6l7
         t82Q==
X-Gm-Message-State: AOAM5318Ssl+IWP3/09zWYCHgYxPww5a9Xq7LRxlliBHtcJ7ithcIR42
        2gTR6GFkxvdzO8UvIXCa/RtB8Kd9PSF0t68Nlmgri8x27rxz+A==
X-Google-Smtp-Source: ABdhPJzkMvCoAnAOijU6t/J5Ack1UKSCtguA0ygpVu6g3JXHgZqEG5cpj+0VLGCL90NRR/kaLQT2FjklIqp6mWnaIbU=
X-Received: by 2002:a17:90a:bf0a:b0:1db:d98d:7ce9 with SMTP id
 c10-20020a17090abf0a00b001dbd98d7ce9mr1478701pjs.155.1651200403930; Thu, 28
 Apr 2022 19:46:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220428121318.43125-1-xiubli@redhat.com>
In-Reply-To: <20220428121318.43125-1-xiubli@redhat.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Fri, 29 Apr 2022 10:46:31 +0800
Message-ID: <CAAM7YAkVEEhhPtO7CJd6Cv6-2qc3EDHwAcU=zggxWSyKjm9aRA@mail.gmail.com>
Subject: Re: [PATCH] ceph: don't retain the caps if they're being revoked and
 not used
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Apr 28, 2022 at 11:42 PM Xiubo Li <xiubli@redhat.com> wrote:
>
> For example if the Frwcb caps are being revoked, but only the Fr
> caps is still being used then the kclient will skip releasing them
> all. But in next turn if the Fr caps is ready to be released the
> Fw caps maybe just being used again. So in corner case, such as
> heavy load IOs, the revocation maybe stuck for a long time.
>
This does not make sense. If Frwcb are being revoked, writer can't get
Fw again. Second, Frwcb are managed by single lock at mds side.
Partial releasing caps does make lock state transition possible.


> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 0c0c8f5ae3b3..7eb5238941fc 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1947,6 +1947,13 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
>
>         /* The ones we currently want to retain (may be adjusted below) */
>         retain = file_wanted | used | CEPH_CAP_PIN;
> +
> +       /*
> +        * Do not retain the capabilities if they are under revoking
> +        * but not used, this could help speed up the revoking.
> +        */
> +       retain &= ~((revoking & retain) & ~used);
> +
>         if (!mdsc->stopping && inode->i_nlink > 0) {
>                 if (file_wanted) {
>                         retain |= CEPH_CAP_ANY;       /* be greedy */
> --
> 2.36.0.rc1
>
