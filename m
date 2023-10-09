Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD867BD4E8
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Oct 2023 10:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345470AbjJIIKj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Oct 2023 04:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345456AbjJIIKh (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 9 Oct 2023 04:10:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD94D94
        for <ceph-devel@vger.kernel.org>; Mon,  9 Oct 2023 01:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696838990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AqPDhZB6/AeVtIYszpl2A9PEXcu7eSDjsahfk9WGBvY=;
        b=DvtV+mgnm0UcoK86QyEF1qC3yTs1AgQxCYez3PtitjHS8KKiklAxgg8EokUGM/1j5WIZZG
        Th/GxIYy6LViYigzaKT6w0kj56P93s8W5uCcTQuvCd6bCbK9E4HexsPvFZWMQuHNJfbTBl
        a879PJIvP4xMEg63K9g+Iur09CfAq3w=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-343-8YpmtAQ6NXiwcLK8Lr3OQw-1; Mon, 09 Oct 2023 04:09:33 -0400
X-MC-Unique: 8YpmtAQ6NXiwcLK8Lr3OQw-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-9ae70250ef5so571867266b.0
        for <ceph-devel@vger.kernel.org>; Mon, 09 Oct 2023 01:09:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696838971; x=1697443771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AqPDhZB6/AeVtIYszpl2A9PEXcu7eSDjsahfk9WGBvY=;
        b=bcjZHVHpLpymaCfAC4LD1b4Y3GU6//lDrhV9K2fWWSQVdhyiwmqn1+hqtHhVWxsFES
         iiqKpCe5brHPacbHr0WWm6RfqYqmtKREWsemjCQPAAHBPALZBCJVNmkJzlpvgNZY4pV5
         uvw1HlGK+iwucaJGLiJ9a56haPLWtxLtNUP6Ko0PD6xx/0bi1d/2nR6lBYR6+57UxMcu
         G+/ESTcbIhDHjqEQfkU2nMe/BYmYSAhDoIbb2n76BH/XZnmGK4S8ScLCCQCSxoMX/jog
         x29aOSdATXnsjAdjlQsiCAO+8HE53J0h+Zr4V/d2jjiITepLcLaGxfYQcgt2VNehRSyd
         MaPQ==
X-Gm-Message-State: AOJu0YwTG+X6VCI8yQuN3iPl3Ur3EN576U1/N3icxROSfoueyspUdREW
        liyEEMizuXcr8sJwlbnMpVQPlcLyTX/8bOaqUDdWPKtpnSx/xJb1XExkDtC9eUJk+G/QDtvCYX9
        3+nfOu0pOUg1+b030huSeSPX8PtRelfHkmpjkxg==
X-Received: by 2002:a17:906:739c:b0:9a1:ca55:d0cb with SMTP id f28-20020a170906739c00b009a1ca55d0cbmr10743956ejl.23.1696838971767;
        Mon, 09 Oct 2023 01:09:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFmlWzwg4gDqOfBiB3fQBb8xrlYRnlav6xsAYgYZnmAfFLAQTsEXYXh3I/cro0z8JHTx2pAY+ucplFtAtlXVwQ=
X-Received: by 2002:a17:906:739c:b0:9a1:ca55:d0cb with SMTP id
 f28-20020a170906739c00b009a1ca55d0cbmr10743939ejl.23.1696838971440; Mon, 09
 Oct 2023 01:09:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230907002211.633935-1-xiubli@redhat.com>
In-Reply-To: <20230907002211.633935-1-xiubli@redhat.com>
From:   Milind Changire <mchangir@redhat.com>
Date:   Mon, 9 Oct 2023 13:38:55 +0530
Message-ID: <CAED=hWCKc-pnMQUKmjwgyG5489c5OjUHt-ri2gL+Ps1hGdewrw@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: remove the incorrect caps check in _file_size()
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Looks good to me

Reviewed-by: Milind Changire <mchangir@redhat.com>

On Thu, Sep 7, 2023 at 5:54=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> When truncating the inode the MDS will acquire the xlock for the
> ifile Locker, which will revoke the 'Frwsxl' caps from the clients.
> But when the client just releases and flushes the 'Fw' caps to MDS,
> for exmaple, and once the MDS receives the caps flushing msg it
> just thought the revocation has finished. Then the MDS will continue
> truncating the inode and then issued the truncate notification to
> all the clients. While just before the clients receives the cap
> flushing ack they receive the truncation notification, the clients
> will detecte that the 'issued | dirty' is still holding the 'Fw'
> caps.
>
> Fixes: b0d7c2231015 ("ceph: introduce i_truncate_mutex")
> Cc: stable@vger.kernel.org
> URL: https://tracker.ceph.com/issues/56693
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> V2:
> - Added the info about which commit it's fixing
>
>
>  fs/ceph/inode.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index ea6f966dacd5..8017b9e5864f 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -769,9 +769,7 @@ int ceph_fill_file_size(struct inode *inode, int issu=
ed,
>                         ci->i_truncate_seq =3D truncate_seq;
>
>                         /* the MDS should have revoked these caps */
> -                       WARN_ON_ONCE(issued & (CEPH_CAP_FILE_EXCL |
> -                                              CEPH_CAP_FILE_RD |
> -                                              CEPH_CAP_FILE_WR |
> +                       WARN_ON_ONCE(issued & (CEPH_CAP_FILE_RD |
>                                                CEPH_CAP_FILE_LAZYIO));
>                         /*
>                          * If we hold relevant caps, or in the case where=
 we're
> --
> 2.41.0
>


--=20
Milind

