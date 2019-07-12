Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF986648F
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Jul 2019 04:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729091AbfGLCqU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 11 Jul 2019 22:46:20 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44175 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728866AbfGLCqT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 11 Jul 2019 22:46:19 -0400
Received: by mail-qt1-f194.google.com with SMTP id 44so6620522qtg.11
        for <ceph-devel@vger.kernel.org>; Thu, 11 Jul 2019 19:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P2XBgF1CzOs1aWI6odvKhDjrJYnojFfcAVQ7Hs9w3Cg=;
        b=kyG23uysEd/D5KwaZhJarjhNuiC+EmJ42CdN9fKArbMjdwOhn/dQI6FfzobLz/E0NB
         jc3ntitaGrSrLBPKqQVZRrqd7FPO2aPknZSeb243ClJP/up/qlRyMZKzz0/yJb5LnlHL
         TaG2TjukAeYlSyo3omtOsr4ewq5TsgKCeaE3NfRxeMLXPl6NuLI6Kfsij5m8IjwWgFhZ
         d/Jxotkg7YwpXr9pGDt2XuCWn2CZtZ7gLfn4o+QBWVkXyAPhWlrn1+MTeKQz1SGVM4on
         Qlnq627QW6FD16KaCcHQjXkWyGKNoPcfzpjB0wKILiy/9g+CaA4Btx8B1PJmR0iYCshZ
         EQNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P2XBgF1CzOs1aWI6odvKhDjrJYnojFfcAVQ7Hs9w3Cg=;
        b=OrAvN2yR07X7CRQpwiOCr2qyFKA7pSTtN+U/5O6ZJn5KNfMLsdzbpJnKItuEAkXbMA
         C5bSKHx5juMFh9EBF/v7aHa5qfi2mG8hxsg8f8yfCOsReabHLwZKbasuoDXip6bd0G+a
         Qix8Z4DIP/w1GwYJjoXRthRyW5mHhKbNKEQZEwcZdC6uhGAw/GEK/oSm3YhFmieLnpQ3
         kNBLawAKwf2gUHbJbCGqHz+kx3T8ONUhFTSb4hVgosQjqIN8AY03J/OLRdswk+r7hgdl
         jaq2dIcml//DlEGksLuJyC6WQxQWx9rSJZGGz3zDBanJV/L++idzTrQW0SCena80cfRT
         lLqA==
X-Gm-Message-State: APjAAAV6Cvl4FvcbLVa6Z1F6JFndhXth7hux0lguFCjRclMkxO3bp2jy
        WB2o41pcsAUd62OpviApm7C5XelvCAWX6mMT35M=
X-Google-Smtp-Source: APXvYqxPhc0dbhZOkNgf4I6W+QGU8frF5he0hilpnHtlHOmbUqaY+3C7z6oe4i7aoy1Ly9Ksi4ogmAZBGUU7IY28jG8=
X-Received: by 2002:ac8:3637:: with SMTP id m52mr4383890qtb.238.1562899578925;
 Thu, 11 Jul 2019 19:46:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190711184136.19779-1-jlayton@kernel.org> <20190711184136.19779-6-jlayton@kernel.org>
In-Reply-To: <20190711184136.19779-6-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Fri, 12 Jul 2019 10:46:07 +0800
Message-ID: <CAAM7YAk=CWNCFrk7cudTHY4Gt0u_izjsRV8M=uZEOqTd-e2PTA@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] ceph: handle inlined files in copy_file_range
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Zheng Yan <zyan@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Sage Weil <sage@redhat.com>,
        Luis Henriques <lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jul 12, 2019 at 3:17 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> If the src is inlined, then just bail out. Have it attempt to uninline
> the dst file however.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/file.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 252aac44b8ce..774f51b0b63d 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1934,6 +1934,10 @@ static ssize_t ceph_copy_file_range(struct file *src_file, loff_t src_off,
>         if (len < src_ci->i_layout.object_size)
>                 return -EOPNOTSUPP; /* no remote copy will be done */
>
> +       /* Fall back if src file is inlined */
> +       if (READ_ONCE(src_ci->i_inline_version) != CEPH_INLINE_NONE)
> +               return -EOPNOTSUPP;
> +
>         prealloc_cf = ceph_alloc_cap_flush();
>         if (!prealloc_cf)
>                 return -ENOMEM;
> @@ -1967,6 +1971,13 @@ static ssize_t ceph_copy_file_range(struct file *src_file, loff_t src_off,
>         if (ret < 0)
>                 goto out_caps;
>
> +       /* uninline the dst inode */
> +       dirty = ceph_uninline_data(dst_inode, NULL);
> +       if (dirty < 0) {
> +               ret = dirty;
> +               goto out_caps;
> +       }
> +
>         size = i_size_read(dst_inode);
>         endoff = dst_off + len;
>
> @@ -2080,7 +2091,7 @@ static ssize_t ceph_copy_file_range(struct file *src_file, loff_t src_off,
>         /* Mark Fw dirty */
>         spin_lock(&dst_ci->i_ceph_lock);
>         dst_ci->i_inline_version = CEPH_INLINE_NONE;
remove this line

> -       dirty = __ceph_mark_dirty_caps(dst_ci, CEPH_CAP_FILE_WR, &prealloc_cf);
> +       dirty |= __ceph_mark_dirty_caps(dst_ci, CEPH_CAP_FILE_WR, &prealloc_cf);
>         spin_unlock(&dst_ci->i_ceph_lock);
>         if (dirty)
>                 __mark_inode_dirty(dst_inode, dirty);
> --
> 2.21.0
>
