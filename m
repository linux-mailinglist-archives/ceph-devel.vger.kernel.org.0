Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D07D73FD09
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Jun 2023 15:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbjF0Nnj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Jun 2023 09:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjF0Nni (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 27 Jun 2023 09:43:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F01211B
        for <ceph-devel@vger.kernel.org>; Tue, 27 Jun 2023 06:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687873373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rm8eNxi9U5TQT5l3JCNmEbe34/5VjWHVvsVeuJmv90Q=;
        b=C8kZsaKaV0kGkHDyJN9RSQ+gTYPRSTpDirlfpKcbtZDbRQGYhzq2raiUhN0eSpNFtXu+v4
        03R45+holMRwzSjzVaMkgIBhz9FLg7YSbHQnRnEB8BeUQGlf03h3ejR15L1ELSBo8fKbz9
        VDd7/kwqr+xPFBOw+KQaO7JO9CugBIQ=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-504--ByX99NaND6Ed-ItR3xChw-1; Tue, 27 Jun 2023 09:42:52 -0400
X-MC-Unique: -ByX99NaND6Ed-ItR3xChw-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-9715654aba1so520317366b.0
        for <ceph-devel@vger.kernel.org>; Tue, 27 Jun 2023 06:42:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687873371; x=1690465371;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rm8eNxi9U5TQT5l3JCNmEbe34/5VjWHVvsVeuJmv90Q=;
        b=aRBUEGud3CZFOPocr4To0l+vnYicmLualjjWwFbqmz2qgsKfQ1WD7piBujlbZzkUPt
         SeTTz/OkhttowRM+YXrMkMfl/r+vqfVHT9jqB9DqZGF1jLS/XYBIS6CU5HCUwVQItUCT
         0NtPXBn/eb6yI0R/vzY6NJ6s0zWBpUFB+TMwGcNolMY+q9sb7/SJT8Jz4BY1LNhMScYI
         YLOOctU6Za6aaWnwCMwZ4Kq1LA0e+bhcYT5EyyQAZFVo/VcNn6RqYhKyLA3Oh0fjMz0Q
         WiB81lHhsn9muhKIXyilJgswwOZfIHX2fyBVMiSHpYZ81Qc4kZOLzDuF8wWfu2ldqye9
         qWRw==
X-Gm-Message-State: AC+VfDyGrvNKbe3bD/+wQpr+JzglFhnmXeIVl1qLQCf7Q387SGLsS8YH
        /RraGXnPREY8atOCTtzxbfmmpwGMfd76IoqFqfA3mV+kvs0T7+TLHNKcNJazdOg4MHlHHL7UmfP
        dYaj/TMSY8ssTAlB9veFc87tfkv4OyD2EbzBR3A==
X-Received: by 2002:a17:907:6e18:b0:98f:450e:fc20 with SMTP id sd24-20020a1709076e1800b0098f450efc20mr6399605ejc.17.1687873371598;
        Tue, 27 Jun 2023 06:42:51 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7TujCrDk13a7rny2KScteZ+GMisRjXSMXh1ANdbMfdEjxe2hUa75VA3ivzcUzxUfMqKF4ZWSJHfzntbxwwVbg=
X-Received: by 2002:a17:907:6e18:b0:98f:450e:fc20 with SMTP id
 sd24-20020a1709076e1800b0098f450efc20mr6399589ejc.17.1687873371360; Tue, 27
 Jun 2023 06:42:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230618231011.9077-1-xiubli@redhat.com>
In-Reply-To: <20230618231011.9077-1-xiubli@redhat.com>
From:   Milind Changire <mchangir@redhat.com>
Date:   Tue, 27 Jun 2023 19:12:15 +0530
Message-ID: <CAED=hWBqyq2Bi01X+=MXuncxq4MrPyUHrPthgnbYne5gRqCzLg@mail.gmail.com>
Subject: Re: [PATCH] ceph: issue a cap release immediately if no cap exists
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Looks good to me.

Reviewed-by: Milind Changire <mchangir@redhat.com>

On Mon, Jun 19, 2023 at 4:42=E2=80=AFAM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> In case:
>
>            mds                             client
>                                 - Releases cap and put Inode
>   - Increase cap->seq and sends
>     revokes req to the client
>   - Receives release req and    - Receives & drops the revoke req
>     skip removing the cap and
>     then eval the CInode and
>     issue or revoke caps again.
>                                 - Receives & drops the caps update
>                                   or revoke req
>   - Health warning for client
>     isn't responding to
>     mclientcaps(revoke)
>
> All the IMPORT/REVOKE/GRANT cap ops will increase the session seq
> in MDS side and then the client need to issue a cap release to
> unblock MDS to remove the corresponding cap to unblock possible
> waiters.
>
> URL: https://tracker.ceph.com/issues/61332
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/caps.c | 40 +++++++++++++++++++++++++++++-----------
>  1 file changed, 29 insertions(+), 11 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 5498bc36c1e7..59ab5d905ac4 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -4232,6 +4232,7 @@ void ceph_handle_caps(struct ceph_mds_session *sess=
ion,
>         struct cap_extra_info extra_info =3D {};
>         bool queue_trunc;
>         bool close_sessions =3D false;
> +       bool do_cap_release =3D false;
>
>         dout("handle_caps from mds%d\n", session->s_mds);
>
> @@ -4349,17 +4350,14 @@ void ceph_handle_caps(struct ceph_mds_session *se=
ssion,
>                 else
>                         dout(" i don't have ino %llx\n", vino.ino);
>
> -               if (op =3D=3D CEPH_CAP_OP_IMPORT) {
> -                       cap =3D ceph_get_cap(mdsc, NULL);
> -                       cap->cap_ino =3D vino.ino;
> -                       cap->queue_release =3D 1;
> -                       cap->cap_id =3D le64_to_cpu(h->cap_id);
> -                       cap->mseq =3D mseq;
> -                       cap->seq =3D seq;
> -                       cap->issue_seq =3D seq;
> -                       spin_lock(&session->s_cap_lock);
> -                       __ceph_queue_cap_release(session, cap);
> -                       spin_unlock(&session->s_cap_lock);
> +               switch (op) {
> +               case CEPH_CAP_OP_IMPORT:
> +               case CEPH_CAP_OP_REVOKE:
> +               case CEPH_CAP_OP_GRANT:
> +                       do_cap_release =3D true;
> +                       break;
> +               default:
> +                       break;
>                 }
>                 goto flush_cap_releases;
>         }
> @@ -4413,6 +4411,14 @@ void ceph_handle_caps(struct ceph_mds_session *ses=
sion,
>                         pr_info("%s: no cap on %p ino %llx:%llx from mds%=
d for flush_ack!\n",
>                                 __func__, inode, ceph_ino(inode),
>                                 ceph_snap(inode), session->s_mds);
> +               switch (op) {
> +               case CEPH_CAP_OP_REVOKE:
> +               case CEPH_CAP_OP_GRANT:
> +                       do_cap_release =3D true;
> +                       break;
> +               default:
> +                       break;
> +               }
>                 goto flush_cap_releases;
>         }
>
> @@ -4467,6 +4473,18 @@ void ceph_handle_caps(struct ceph_mds_session *ses=
sion,
>          * along for the mds (who clearly thinks we still have this
>          * cap).
>          */
> +       if (do_cap_release) {
> +               cap =3D ceph_get_cap(mdsc, NULL);
> +               cap->cap_ino =3D vino.ino;
> +               cap->queue_release =3D 1;
> +               cap->cap_id =3D le64_to_cpu(h->cap_id);
> +               cap->mseq =3D mseq;
> +               cap->seq =3D seq;
> +               cap->issue_seq =3D seq;
> +               spin_lock(&session->s_cap_lock);
> +               __ceph_queue_cap_release(session, cap);
> +               spin_unlock(&session->s_cap_lock);
> +       }
>         ceph_flush_cap_releases(mdsc, session);
>         goto done;
>
> --
> 2.40.1
>


--=20
Milind

