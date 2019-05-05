Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B005713E37
	for <lists+ceph-devel@lfdr.de>; Sun,  5 May 2019 09:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727542AbfEEHoc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 5 May 2019 03:44:32 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36194 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbfEEHoc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 5 May 2019 03:44:32 -0400
Received: by mail-qk1-f194.google.com with SMTP id c14so2353261qke.3
        for <ceph-devel@vger.kernel.org>; Sun, 05 May 2019 00:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z/xT5/gD2jyszPvtk+5p70DNFQlG5SUGRHQKfuLLKP4=;
        b=STb9wMb3dVn9BLd2pLjlGRBfOwhsVCLsV2x53gArx2aDFrJYxoDSptr0G4zVNGYSn5
         NZpsD7gITW3jrjYNAHDSOKU24o7VHcFSygIWlCaq/t0B/D5adTMU0iSVVFQUBzvXiULJ
         scTL9c02Xptx0V2bqMofIVnB0Q3AiHV/T37/IQDeSD0ab4zj7iIwkHVir5vHdnSVGa3e
         tN/PlcEBWUx0KnTDzHYWwcFDs7TkY+IH4wsDIZybESmHBUm5Fg02DaqovW07e261Fiyo
         LmOcun2n1L3oxMUIZGXWeRMgGKwNkRf/tTyIndYJLNMm5JijFhkiescwixgot+1SnyA7
         SvXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z/xT5/gD2jyszPvtk+5p70DNFQlG5SUGRHQKfuLLKP4=;
        b=i//rN2Fxi36Krw+frLEqxaic66oEaOeAV3JIpozVEL2caJdh4v9vxjy8IpP909sxyj
         a+YWahqbQHCIbDTLxpGBTRa5TOdrc/R9U/cbKurWf1nw1VvBCgAOptTvgnzetXES/CMu
         t154w9L8y2HtZ6T2sHPKv3A7Cqz+JWON4cXkukGPScW/EFxbJ750gtPg46mnuKHG8BLS
         MCa9qRyrAnwQ7PjBTMM/27el0fsMGTCqYnTrr2Edua568p/Kbi/c1J0K53FqbcWcmFDi
         MPmZ+a3p8kdROa5qnxc6oUMrNCMlg6iOUHnODgRrGgpYxThhjktmeZDZjRWzf0/PPeKl
         VOsA==
X-Gm-Message-State: APjAAAXXqeGTqg79Wzuf3pC5pGBesj20QL1GbeAvv/ATdM4tqG5kSaSV
        R4VjgWdoy50tMemPiUDU82t2slfVhls43Ttp61I=
X-Google-Smtp-Source: APXvYqzIbcUrkVdPmEoxNn08mfVo02lhHYGEgcaFPP+jF3RDzuL2cd9cmD0lIlnxDgkZIG8s4SXFhOF8Pf6ZptPwRHk=
X-Received: by 2002:a37:9bc2:: with SMTP id d185mr14242346qke.246.1557042271742;
 Sun, 05 May 2019 00:44:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190502184638.3614-1-jlayton@kernel.org> <20190502184638.3614-3-jlayton@kernel.org>
In-Reply-To: <20190502184638.3614-3-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Sun, 5 May 2019 15:44:20 +0800
Message-ID: <CAAM7YAnBTM_77Sk2+JdJ8JbmWHkzO7vobQpL_jfLCogn=ZTKHw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ceph: fix unaligned access in ceph_send_cap_releases
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Zheng Yan <zyan@redhat.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, May 3, 2019 at 2:50 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/mds_client.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index e09773a7a9cf..66eae336a68a 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -1855,7 +1855,8 @@ static void ceph_send_cap_releases(struct ceph_mds_client *mdsc,
>                 num_cap_releases--;
>
>                 head = msg->front.iov_base;
> -               le32_add_cpu(&head->num, 1);
> +               put_unaligned_le32(get_unaligned_le32(&head->num) + 1,
> +                                  &head->num);
>                 item = msg->front.iov_base + msg->front.iov_len;
>                 item->ino = cpu_to_le64(cap->cap_ino);
>                 item->cap_id = cpu_to_le64(cap->cap_id);
> --
> 2.21.0
>

Reviewed-by: "Yan, Zheng" <zyan@redhat.com
