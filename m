Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 557A83F2663
	for <lists+ceph-devel@lfdr.de>; Fri, 20 Aug 2021 07:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238319AbhHTFRB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 20 Aug 2021 01:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238221AbhHTFQ7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 20 Aug 2021 01:16:59 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04FBC061760
        for <ceph-devel@vger.kernel.org>; Thu, 19 Aug 2021 22:16:19 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id b15so17577902ejg.10
        for <ceph-devel@vger.kernel.org>; Thu, 19 Aug 2021 22:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eJKMtiL35vwYKQrf585/+oh28eNMk4VxCXNUyyU7WUA=;
        b=iQvmdblkZr9k+v/zfn8MVnmf10/tSDE73kmqF/BYCHoNkJHJOewhIcLytH38qL5VaH
         7jPFlCGE9w7ncq0+4/ZnsRDMLgjzR33x0AFiuNJsB+SaQnRZ2IOZO2LVZfj2gUqFNpCV
         Du23KxUgAzIPSt5ytfXEG4JFbV/7UX+ggPPOaUOp3HNB4DfKI5QO2DPeTKRQM14oRItk
         LNfGsOEihIkCmthj22GFn4qjvcWr5zW5/kl1O1npEZTSrWYIr9L/aFCMxuAXUTTghWTw
         httg8+fe/GdQkDNYOXv6nBDevsWyFczO4JEO4jl4KTl27lBgQcAcJij9eDX+CJWZ/MJb
         n6Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eJKMtiL35vwYKQrf585/+oh28eNMk4VxCXNUyyU7WUA=;
        b=BgnFyAuDxIOri6bPPMFAGf4cA7TWZCGTMwHLEAL6zk2rZdPLo43RBpiS8fSblOmBuB
         2PGL0OsPFKHceQa70NGNLeiBNGyEs4MPgMWo1l5m60Hkqez3NwE8h+u8/0BUJJtol/cd
         +XFOL4fjOD8S0BthY7wbDoRdtUvDpYpmzoUBi/ABHBMBoYf28pkqXnhFIv3+KspkRPKZ
         ddlUVfu+e7c3uFtN0V3QLChUI0GYd6jqycQOJH8Rit8sBoCYCoFonQOsUGQtPfgSWfXQ
         vr8cYwjpJ92+h24Gh9BTwxFXoMAvclvdtD6LdgIWxPhdumx92JlSOt088MqwWSCTKQCt
         GThw==
X-Gm-Message-State: AOAM532LxkQVaFsPA34X3vexRYqLPS5T2bV9tGoGGKiHYjtwkgZrSLTr
        qx8uKBamkOW6VHIHjJm3A/as5GU7ac4vE3PYzkA=
X-Google-Smtp-Source: ABdhPJwkgVxdA23ywzM6IkR258fDyvagY278l8+qiIE+sZLUBmnxSJs+x3NS2qV5b8Iutd3lFf0DuIkLJAvTPBuhL1c=
X-Received: by 2002:a17:906:2ad5:: with SMTP id m21mr19619413eje.88.1629436578510;
 Thu, 19 Aug 2021 22:16:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210811112324.8870-1-jlayton@kernel.org>
In-Reply-To: <20210811112324.8870-1-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Fri, 20 Aug 2021 13:16:05 +0800
Message-ID: <CAAM7YAnGbhTmHVUVK_0Ve0P+R45J7iuk9VicuQZAA-YsN470uA@mail.gmail.com>
Subject: Re: [PATCH] ceph: request Fw caps before updating the mtime in ceph_write_iter
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Luis Henriques <lhenriques@suse.de>,
        Xiubo Li <xiubli@redhat.com>,
        =?UTF-8?B?Sm96ZWYgS292w6HEjQ==?= <kovac@firma.zoznam.sk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Aug 11, 2021 at 7:24 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> The current code will update the mtime and then try to get caps to
> handle the write. If we end up having to request caps from the MDS, then
> the mtime in the cap grant will clobber the updated mtime and it'll be
> lost.
>
> This is most noticable when two clients are alternately writing to the
> same file. Fw caps are continually being granted and revoked, and the
> mtime ends up stuck because the updated mtimes are always being
> overwritten with the old one.
>
> Fix this by changing the order of operations in ceph_write_iter. Get the
> caps much earlier, and only update the times afterward. Also, make sure
> we check the NEARFULL conditions before making any changes to the inode.
>
> URL: https://tracker.ceph.com/issues/46574
> Reported-by: Jozef Kov=C3=A1=C4=8D <kovac@firma.zoznam.sk>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/file.c | 34 +++++++++++++++++-----------------
>  1 file changed, 17 insertions(+), 17 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index f55ca2c4c7de..5867acfc6a51 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1722,22 +1722,6 @@ static ssize_t ceph_write_iter(struct kiocb *iocb,=
 struct iov_iter *from)
>                 goto out;
>         }
>
> -       err =3D file_remove_privs(file);
> -       if (err)
> -               goto out;
> -
> -       err =3D file_update_time(file);
> -       if (err)
> -               goto out;
> -
> -       inode_inc_iversion_raw(inode);
> -
> -       if (ci->i_inline_version !=3D CEPH_INLINE_NONE) {
> -               err =3D ceph_uninline_data(file, NULL);
> -               if (err < 0)
> -                       goto out;
> -       }
> -
>         down_read(&osdc->lock);
>         map_flags =3D osdc->osdmap->flags;
>         pool_flags =3D ceph_pg_pool_flags(osdc->osdmap, ci->i_layout.pool=
_id);
> @@ -1748,6 +1732,12 @@ static ssize_t ceph_write_iter(struct kiocb *iocb,=
 struct iov_iter *from)
>                 goto out;
>         }
>
> +       if (ci->i_inline_version !=3D CEPH_INLINE_NONE) {
> +               err =3D ceph_uninline_data(file, NULL);
> +               if (err < 0)
> +                       goto out;
> +       }
> +
>         dout("aio_write %p %llx.%llx %llu~%zd getting caps. i_size %llu\n=
",
>              inode, ceph_vinop(inode), pos, count, i_size_read(inode));
>         if (fi->fmode & CEPH_FILE_MODE_LAZY)
> @@ -1759,6 +1749,16 @@ static ssize_t ceph_write_iter(struct kiocb *iocb,=
 struct iov_iter *from)
>         if (err < 0)
>                 goto out;
>
> +       err =3D file_remove_privs(file);
> +       if (err)
> +               goto out_caps;

this may send setattr request to mds. holding cap here may cause deadlock.

> +
> +       err =3D file_update_time(file);
> +       if (err)
> +               goto out_caps;
> +
> +       inode_inc_iversion_raw(inode);
> +
>         dout("aio_write %p %llx.%llx %llu~%zd got cap refs on %s\n",
>              inode, ceph_vinop(inode), pos, count, ceph_cap_string(got));
>
> @@ -1822,7 +1822,7 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, =
struct iov_iter *from)
>                 if (ceph_quota_is_max_bytes_approaching(inode, iocb->ki_p=
os))
>                         ceph_check_caps(ci, 0, NULL);
>         }
> -
> +out_caps:
>         dout("aio_write %p %llx.%llx %llu~%u  dropping cap refs on %s\n",
>              inode, ceph_vinop(inode), pos, (unsigned)count,
>              ceph_cap_string(got));
> --
> 2.31.1
>
