Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF12706547
	for <lists+ceph-devel@lfdr.de>; Wed, 17 May 2023 12:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbjEQKbk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 May 2023 06:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjEQKbj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 17 May 2023 06:31:39 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AD7A3A80;
        Wed, 17 May 2023 03:31:26 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-50be17a1eceso1016369a12.2;
        Wed, 17 May 2023 03:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684319484; x=1686911484;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jN2Qt6wopwsb1soSBiO1ksV6jX/xuz/JqjaDyhZdAzU=;
        b=o3BDKCwKTkT31Lg+1H59ZpTNXUahuFguoXQwVOZTIYsd3qPeEBFmKCeF1qTCKlZ5/D
         1KgVdHOnyIRYy8DzXvRDWA4arFfqV26JcX65FBGdGfrmAKpvl5UHAC7g7MDLrn048aUX
         X1imOYkJNDeP1ja6Abk13jXhlIysdiA030N5H4Yu7s1s+Pv4PGaM0nmRSJkFKHa4PMnB
         NPIOycbULdhaGQrzjrFU2wrMQVX8p6FsWv1tkQ4vJ0ryON9PRo8pmPlbdPambNztlp+g
         P4OtNBAN2CCO0HP/t2JXB0psYRMtRaDiyl9Lq+KxgdxmE3XhBCEt1hYNCg1Zbq3dV/3D
         SHEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684319484; x=1686911484;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jN2Qt6wopwsb1soSBiO1ksV6jX/xuz/JqjaDyhZdAzU=;
        b=exkCapbBA7QSZEqt1xwil+JxwmN4b8XpbCWVgDzdUyC+YHF7cJgOPjWotmvmcXJlJY
         68IvVmx8L7bD3YaQveiLce4eZGR/E4lhhEeYwPdEHImxFl2MGA6dmcde80Ym+/NARiLV
         C6UOR8xWqQMVZNdcVbGrId19DaS5wDpnEgcIixRSMoiJU/Fm1x2qWE55l51U5Bs7GLIj
         abkmTdoLQcA0SMlC0aVPayCrE2LL8nMHFPGH8QP9YgDzhpD/ujL5bS+/xqdiF5urgo6Y
         7HLReI0o5JRlYVDyDG2JXfE8zjvMqCkRvcKKXczEDPSN4d7O/bmkSIRvrLbeYTu9U2vb
         hUZQ==
X-Gm-Message-State: AC+VfDyGqKJ1IlPw/04xfLMV0p3DXDBEpVUH83e0eoXdoMbgXnIjolXD
        y56PsZROdWrAftpAFbbHPVRIm6PobjOPGE9P39U=
X-Google-Smtp-Source: ACHHUZ5x4IdMM2FXItbpDrPQGuKOzYB4tamRNFVWupGDPKTGSrBunps9PHXI0UIug4gw0BseSFROyr760D9cGfqMKcg=
X-Received: by 2002:a17:907:7da0:b0:96a:ed6e:7d58 with SMTP id
 oz32-20020a1709077da000b0096aed6e7d58mr13577830ejc.7.1684319484414; Wed, 17
 May 2023 03:31:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230517052404.99904-1-xiubli@redhat.com>
In-Reply-To: <20230517052404.99904-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 17 May 2023 12:31:12 +0200
Message-ID: <CAOi1vP8e6NrrrV5TLYS-DpkjQN6LhfqkptR5_ue94HcHJV_2ag@mail.gmail.com>
Subject: Re: [PATCH] ceph: force updating the msg pointer in non-split case
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, stable@vger.kernel.org,
        Frank Schilder <frans@dtu.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, May 17, 2023 at 7:24=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> When the MClientSnap reqeust's op is not CEPH_SNAP_OP_SPLIT the
> request may still contain a list of 'split_realms', and we need
> to skip it anyway. Or it will be parsed as a corrupt snaptrace.
>
> Cc: stable@vger.kernel.org
> Cc: Frank Schilder <frans@dtu.dk>
> Reported-by: Frank Schilder <frans@dtu.dk>
> URL: https://tracker.ceph.com/issues/61200
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/snap.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index 0e59e95a96d9..d95dfe16b624 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -1114,6 +1114,9 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>                                 continue;
>                         adjust_snap_realm_parent(mdsc, child, realm->ino)=
;
>                 }
> +       } else {
> +               p +=3D sizeof(u64) * num_split_inos;
> +               p +=3D sizeof(u64) * num_split_realms;
>         }
>
>         /*
> --
> 2.40.1
>

Hi Xiubo,

This code appears to be very old -- it goes back to the initial commit
963b61eb041e ("ceph: snapshot management") in 2009.  Do you have an
explanation for why this popped up only now?

Has MDS always been including split_inos and split_realms arrays in
!CEPH_SNAP_OP_SPLIT case or is this a recent change?  If it's a recent
change, I'd argue that this needs to be addressed on the MDS side.

Thanks,

                Ilya
