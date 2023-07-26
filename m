Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B40763321
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jul 2023 12:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233351AbjGZKGi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Jul 2023 06:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233189AbjGZKGc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Jul 2023 06:06:32 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC7D1FCB
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jul 2023 03:06:27 -0700 (PDT)
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id BA9033F32E
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jul 2023 10:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1690365984;
        bh=rNrgf1mOreh2KcNpGKBlQnbpZK6Fx9m90RMHwL9HVa4=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=twSGCjVCHfYedKS41NQ15ZQ2YxKenseyi+tIYOfHnOf5gjP2lxmkk+Cx94Q6TMGjS
         eqi6aDMCl/O6vw8KYJxwFI7AS/06pXL4Nm1bxKqKlrP6EKz4FdQATP03ZXGlKgeLXx
         tzVsJ/407B6V9HVDwSKcOeQ++SVZ5LkTUkrKBpZrh2vOpCKtuOW5GVB0+oWWZHkGlt
         hRY2QAMyBuPZUBrt9mXEaOCK+tKjW0dODxwJsCLo3evbKBwsB+hQ3IBiXgJGTUr+T3
         HOnSvs8zlStVkz9yEQs2oDA17p6jlHCZDqdWaQgoYIThV1OY56b35XbzShOM/82t97
         HWIVEDkLfMLLg==
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-3a3a70425b4so12257475b6e.3
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jul 2023 03:06:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690365983; x=1690970783;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rNrgf1mOreh2KcNpGKBlQnbpZK6Fx9m90RMHwL9HVa4=;
        b=Gp9VKbpRFz6E6ZD9fvTrz3v1gNKk67lF3y/lhuKBgCOkGAv3YnvnT85Pi6EfaAgeXs
         z9MXsLqdD7ZP+Db3b1Wu3GowTajyVxiWqKQMwl22WFy5Idv4nM3eUjxf7yYQbCpv5ZaL
         mzUnt0gIzVF4ttQyTYianxNDDa+TYDosTz9/MMyk5qmevNQKAus+DzVnUENSq+eZdSwC
         xdSLYpuoXl6/lOCsOgAX2Prt0LgWUw2Dq72aFca0d4sTC4ZARiH2Gizxpqpw6JfhyC2d
         fy5glbh2Wk2GsNYemG+QC4IiLEqUIkqp0iRffWTCYa+fWIqpcEV0ZUXGpcJtuTdTOiDm
         v6pg==
X-Gm-Message-State: ABy/qLZ6BPSzlQMOc0ETuR7qwG2X550kWb9PK7aqnGw5bxLfTtZmkZth
        AQL/c094GvVQULVYc7aP4LhaJfcPqm4etrcLTYJ0TGxBB/yPfDVc7sAeK+Jn/AY97c/A//PI6eT
        UdZYce5wrRUthS59feze8oJ9Wp5vQdx3BOIY/xb0osE8frySTorj9sf0=
X-Received: by 2002:a05:6808:14d2:b0:3a3:65da:1262 with SMTP id f18-20020a05680814d200b003a365da1262mr1986238oiw.10.1690365983499;
        Wed, 26 Jul 2023 03:06:23 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFokyAyrzPD41L2ROV67AxoAxpLbE8JGmU1JTAgAbMunNmvMiqVyp0umbUyBsXP0Di+2IFOnu+W8vHhyb9o5YY=
X-Received: by 2002:a05:6808:14d2:b0:3a3:65da:1262 with SMTP id
 f18-20020a05680814d200b003a365da1262mr1986215oiw.10.1690365983178; Wed, 26
 Jul 2023 03:06:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230725104438.386461-1-xiubli@redhat.com>
In-Reply-To: <20230725104438.386461-1-xiubli@redhat.com>
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Wed, 26 Jul 2023 12:06:12 +0200
Message-ID: <CAEivzxfsi8e3CjYhT5SHOog6TPNsWga6nWNvwQduzJHnL-Bdxw@mail.gmail.com>
Subject: Re: [PATCH] ceph: make num_fwd and num_retry to __u32
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Xiubo!

On Tue, Jul 25, 2023 at 12:46=E2=80=AFPM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> The num_fwd in MClientRequestForward is int32_t, while the num_fwd
> in ceph_mds_request_head is __u8. This is buggy when the num_fwd
> is larger than 256 it will always be truncate to 0 again. But the
> client couldn't recoginize this.
>
> This will make them to __u32 instead. Because the old cephs will
> directly copy the raw memories when decoding the reqeust's head,
> so we need to make sure this kclient will be compatible with old
> cephs. For newer cephs they will decode the requests depending
> the version, which will be much simpler and easier to extend new
> members.
>
> URL: https://tracker.ceph.com/issues/62145
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c         | 191 ++++++++++++++++++-----------------
>  fs/ceph/mds_client.h         |   4 +-
>  include/linux/ceph/ceph_fs.h |  23 ++++-
>  3 files changed, 124 insertions(+), 94 deletions(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 70987b3c198a..191bae3a4ee6 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2897,6 +2897,18 @@ static void encode_mclientrequest_tail(void **p, c=
onst struct ceph_mds_request *
>         }
>  }
>
> +static struct ceph_mds_request_head_legacy *
> +find_legacy_request_head(void *p, u64 features)
> +{
> +       bool legacy =3D !(features & CEPH_FEATURE_FS_BTIME);
> +       struct ceph_mds_request_head_old *ohead;
> +
> +       if (legacy)
> +               return (struct ceph_mds_request_head_legacy *)p;
> +       ohead =3D (struct ceph_mds_request_head_old *)p;
> +       return (struct ceph_mds_request_head_legacy *)&ohead->oldest_clie=
nt_tid;
> +}
> +
>  /*
>   * called under mdsc->mutex
>   */
> @@ -2907,7 +2919,7 @@ static struct ceph_msg *create_request_message(stru=
ct ceph_mds_session *session,
>         int mds =3D session->s_mds;
>         struct ceph_mds_client *mdsc =3D session->s_mdsc;
>         struct ceph_msg *msg;
> -       struct ceph_mds_request_head_old *head;
> +       struct ceph_mds_request_head_legacy *lhead;
>         const char *path1 =3D NULL;
>         const char *path2 =3D NULL;
>         u64 ino1 =3D 0, ino2 =3D 0;
> @@ -2919,6 +2931,7 @@ static struct ceph_msg *create_request_message(stru=
ct ceph_mds_session *session,
>         void *p, *end;
>         int ret;
>         bool legacy =3D !(session->s_con.peer_features & CEPH_FEATURE_FS_=
BTIME);
> +       bool old_version =3D !test_bit(CEPHFS_FEATURE_32BITS_RETRY_FWD, &=
session->s_features);
>
>         ret =3D set_request_path_attr(mdsc, req->r_inode, req->r_dentry,
>                               req->r_parent, req->r_path1, req->r_ino1.in=
o,
> @@ -2950,7 +2963,19 @@ static struct ceph_msg *create_request_message(str=
uct ceph_mds_session *session,
>                 goto out_free2;
>         }
>
> -       len =3D legacy ? sizeof(*head) : sizeof(struct ceph_mds_request_h=
ead);
> +       /*
> +        * For old cephs without supporting the 32bit retry/fwd feature
> +        * it will copy the raw memories directly when decoding the
> +        * requests. While new cephs will decode the head depending the
> +        * version member, so we need to make sure it will be compatible
> +        * with them both.
> +        */
> +       if (legacy)
> +               len =3D sizeof(struct ceph_mds_request_head_legacy);
> +       else if (old_version)
> +               len =3D sizeof(struct ceph_mds_request_head_old);
> +       else
> +               len =3D sizeof(struct ceph_mds_request_head);
>
>         /* filepaths */
>         len +=3D 2 * (1 + sizeof(u32) + sizeof(u64));
> @@ -2995,33 +3020,40 @@ static struct ceph_msg *create_request_message(st=
ruct ceph_mds_session *session,
>
>         msg->hdr.tid =3D cpu_to_le64(req->r_tid);
>
> +       lhead =3D find_legacy_request_head(msg->front.iov_base,
> +                                        session->s_con.peer_features);
> +
>         /*
> -        * The old ceph_mds_request_head didn't contain a version field, =
and
> +        * The ceph_mds_request_head_legacy didn't contain a version fiel=
d, and
>          * one was added when we moved the message version from 3->4.
>          */
>         if (legacy) {
>                 msg->hdr.version =3D cpu_to_le16(3);
> -               head =3D msg->front.iov_base;
> -               p =3D msg->front.iov_base + sizeof(*head);
> +               p =3D msg->front.iov_base + sizeof(*lhead);
> +       } else if (old_version) {
> +               struct ceph_mds_request_head_old *ohead =3D msg->front.io=
v_base;
> +
> +               msg->hdr.version =3D cpu_to_le16(4);
> +               ohead->version =3D cpu_to_le16(CEPH_MDS_REQUEST_HEAD_VERS=
ION);

Don't we want to use the old mds request head version here:
ohead->version =3D cpu_to_le16(1);
?

As far as I understand the idea here is to skip new fields
ext_num_retry/ext_num_fwd in case
when the old_version is true. Would it be incorrect to set version to
the latest one (CEPH_MDS_REQUEST_HEAD_VERSION)
and at the same time skip the setting of new fields?

Kind regards,
Alex

> +               p =3D msg->front.iov_base + sizeof(*ohead);
>         } else {
> -               struct ceph_mds_request_head *new_head =3D msg->front.iov=
_base;
> +               struct ceph_mds_request_head *nhead =3D msg->front.iov_ba=
se;
>
>                 msg->hdr.version =3D cpu_to_le16(6);
> -               new_head->version =3D cpu_to_le16(CEPH_MDS_REQUEST_HEAD_V=
ERSION);
> -               head =3D (struct ceph_mds_request_head_old *)&new_head->o=
ldest_client_tid;
> -               p =3D msg->front.iov_base + sizeof(*new_head);
> +               nhead->version =3D cpu_to_le16(CEPH_MDS_REQUEST_HEAD_VERS=
ION);
> +               p =3D msg->front.iov_base + sizeof(*nhead);
>         }
>
>         end =3D msg->front.iov_base + msg->front.iov_len;
>
> -       head->mdsmap_epoch =3D cpu_to_le32(mdsc->mdsmap->m_epoch);
> -       head->op =3D cpu_to_le32(req->r_op);
> -       head->caller_uid =3D cpu_to_le32(from_kuid(&init_user_ns,
> -                                                req->r_cred->fsuid));
> -       head->caller_gid =3D cpu_to_le32(from_kgid(&init_user_ns,
> -                                                req->r_cred->fsgid));
> -       head->ino =3D cpu_to_le64(req->r_deleg_ino);
> -       head->args =3D req->r_args;
> +       lhead->mdsmap_epoch =3D cpu_to_le32(mdsc->mdsmap->m_epoch);
> +       lhead->op =3D cpu_to_le32(req->r_op);
> +       lhead->caller_uid =3D cpu_to_le32(from_kuid(&init_user_ns,
> +                                                 req->r_cred->fsuid));
> +       lhead->caller_gid =3D cpu_to_le32(from_kgid(&init_user_ns,
> +                                                 req->r_cred->fsgid));
> +       lhead->ino =3D cpu_to_le64(req->r_deleg_ino);
> +       lhead->args =3D req->r_args;
>
>         ceph_encode_filepath(&p, end, ino1, path1);
>         ceph_encode_filepath(&p, end, ino2, path2);
> @@ -3063,7 +3095,7 @@ static struct ceph_msg *create_request_message(stru=
ct ceph_mds_session *session,
>                 p =3D msg->front.iov_base + req->r_request_release_offset=
;
>         }
>
> -       head->num_releases =3D cpu_to_le16(releases);
> +       lhead->num_releases =3D cpu_to_le16(releases);
>
>         encode_mclientrequest_tail(&p, req);
>
> @@ -3114,18 +3146,6 @@ static void complete_request(struct ceph_mds_clien=
t *mdsc,
>         complete_all(&req->r_completion);
>  }
>
> -static struct ceph_mds_request_head_old *
> -find_old_request_head(void *p, u64 features)
> -{
> -       bool legacy =3D !(features & CEPH_FEATURE_FS_BTIME);
> -       struct ceph_mds_request_head *new_head;
> -
> -       if (legacy)
> -               return (struct ceph_mds_request_head_old *)p;
> -       new_head =3D (struct ceph_mds_request_head *)p;
> -       return (struct ceph_mds_request_head_old *)&new_head->oldest_clie=
nt_tid;
> -}
> -
>  /*
>   * called under mdsc->mutex
>   */
> @@ -3136,30 +3156,26 @@ static int __prepare_send_request(struct ceph_mds=
_session *session,
>         int mds =3D session->s_mds;
>         struct ceph_mds_client *mdsc =3D session->s_mdsc;
>         struct ceph_client *cl =3D mdsc->fsc->client;
> -       struct ceph_mds_request_head_old *rhead;
> +       struct ceph_mds_request_head_legacy *lhead;
> +       struct ceph_mds_request_head *nhead;
>         struct ceph_msg *msg;
> -       int flags =3D 0, max_retry;
> +       int flags =3D 0, old_max_retry;
> +       bool old_version =3D !test_bit(CEPHFS_FEATURE_32BITS_RETRY_FWD, &=
session->s_features);
>
> -       /*
> -        * The type of 'r_attempts' in kernel 'ceph_mds_request'
> -        * is 'int', while in 'ceph_mds_request_head' the type of
> -        * 'num_retry' is '__u8'. So in case the request retries
> -        *  exceeding 256 times, the MDS will receive a incorrect
> -        *  retry seq.
> -        *
> -        * In this case it's ususally a bug in MDS and continue
> -        * retrying the request makes no sense.
> -        *
> -        * In future this could be fixed in ceph code, so avoid
> -        * using the hardcode here.
> +       /* Avoid inifinite retrying after overflow. The client will
> +        * increase the retry count and if the MDS is old version,
> +        * so we limit to retry at most 256 times.
>          */
> -       max_retry =3D sizeof_field(struct ceph_mds_request_head, num_retr=
y);
> -       max_retry =3D 1 << (max_retry * BITS_PER_BYTE);
> -       if (req->r_attempts >=3D max_retry) {
> -               pr_warn_ratelimited_client(cl, "request tid %llu seq over=
flow\n",
> -                                          req->r_tid);
> -               return -EMULTIHOP;
> -       }
> +       if (req->r_attempts) {
> +               old_max_retry =3D sizeof_field(struct ceph_mds_request_he=
ad_old, num_retry);
> +               old_max_retry =3D 1 << (old_max_retry * BITS_PER_BYTE);
> +               if ((old_version && req->r_attempts >=3D old_max_retry) |=
|
> +                   ((uint32_t)req->r_attempts >=3D U32_MAX)) {
> +                       pr_warn_ratelimited_client(cl, "%s request tid %l=
lu seq overflow\n",
> +                                                 __func__, req->r_tid);
> +                       return -EMULTIHOP;
> +               }
> +        }
>
>         req->r_attempts++;
>         if (req->r_inode) {
> @@ -3184,20 +3200,24 @@ static int __prepare_send_request(struct ceph_mds=
_session *session,
>                  * d_move mangles the src name.
>                  */
>                 msg =3D req->r_request;
> -               rhead =3D find_old_request_head(msg->front.iov_base,
> -                                             session->s_con.peer_feature=
s);
> +               lhead =3D find_legacy_request_head(msg->front.iov_base,
> +                                                session->s_con.peer_feat=
ures);
>
> -               flags =3D le32_to_cpu(rhead->flags);
> +               flags =3D le32_to_cpu(lhead->flags);
>                 flags |=3D CEPH_MDS_FLAG_REPLAY;
> -               rhead->flags =3D cpu_to_le32(flags);
> +               lhead->flags =3D cpu_to_le32(flags);
>
>                 if (req->r_target_inode)
> -                       rhead->ino =3D cpu_to_le64(ceph_ino(req->r_target=
_inode));
> +                       lhead->ino =3D cpu_to_le64(ceph_ino(req->r_target=
_inode));
>
> -               rhead->num_retry =3D req->r_attempts - 1;
> +               lhead->num_retry =3D req->r_attempts - 1;
> +               if (!old_version) {
> +                       nhead =3D (struct ceph_mds_request_head*)msg->fro=
nt.iov_base;
> +                       nhead->ext_num_retry =3D cpu_to_le32(req->r_attem=
pts - 1);
> +               }
>
>                 /* remove cap/dentry releases from message */
> -               rhead->num_releases =3D 0;
> +               lhead->num_releases =3D 0;
>
>                 p =3D msg->front.iov_base + req->r_request_release_offset=
;
>                 encode_mclientrequest_tail(&p, req);
> @@ -3218,18 +3238,23 @@ static int __prepare_send_request(struct ceph_mds=
_session *session,
>         }
>         req->r_request =3D msg;
>
> -       rhead =3D find_old_request_head(msg->front.iov_base,
> -                                     session->s_con.peer_features);
> -       rhead->oldest_client_tid =3D cpu_to_le64(__get_oldest_tid(mdsc));
> +       lhead =3D find_legacy_request_head(msg->front.iov_base,
> +                                        session->s_con.peer_features);
> +       lhead->oldest_client_tid =3D cpu_to_le64(__get_oldest_tid(mdsc));
>         if (test_bit(CEPH_MDS_R_GOT_UNSAFE, &req->r_req_flags))
>                 flags |=3D CEPH_MDS_FLAG_REPLAY;
>         if (test_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags))
>                 flags |=3D CEPH_MDS_FLAG_ASYNC;
>         if (req->r_parent)
>                 flags |=3D CEPH_MDS_FLAG_WANT_DENTRY;
> -       rhead->flags =3D cpu_to_le32(flags);
> -       rhead->num_fwd =3D req->r_num_fwd;
> -       rhead->num_retry =3D req->r_attempts - 1;
> +       lhead->flags =3D cpu_to_le32(flags);
> +       lhead->num_fwd =3D req->r_num_fwd;
> +       lhead->num_retry =3D req->r_attempts - 1;
> +       if (!old_version) {
> +               nhead =3D (struct ceph_mds_request_head*)msg->front.iov_b=
ase;
> +               nhead->ext_num_fwd =3D cpu_to_le32(req->r_num_fwd);
> +               nhead->ext_num_retry =3D cpu_to_le32(req->r_attempts - 1)=
;
> +       }
>
>         doutc(cl, " r_parent =3D %p\n", req->r_parent);
>         return 0;
> @@ -3893,34 +3918,20 @@ static void handle_forward(struct ceph_mds_client=
 *mdsc,
>         if (test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags)) {
>                 doutc(cl, "forward tid %llu aborted, unregistering\n", ti=
d);
>                 __unregister_request(mdsc, req);
> -       } else if (fwd_seq <=3D req->r_num_fwd) {
> -               /*
> -                * The type of 'num_fwd' in ceph 'MClientRequestForward'
> -                * is 'int32_t', while in 'ceph_mds_request_head' the
> -                * type is '__u8'. So in case the request bounces between
> -                * MDSes exceeding 256 times, the client will get stuck.
> -                *
> -                * In this case it's ususally a bug in MDS and continue
> -                * bouncing the request makes no sense.
> +       } else if (fwd_seq <=3D req->r_num_fwd || (uint32_t)fwd_seq >=3D =
U32_MAX) {
> +               /* Avoid inifinite retrying after overflow.
>                  *
> -                * In future this could be fixed in ceph code, so avoid
> -                * using the hardcode here.
> +                * The MDS will increase the fwd count and in client side
> +                * if the num_fwd is less than the one saved in request
> +                * that means the MDS is an old version and overflowed of
> +                * 8 bits.
>                  */
> -               int max =3D sizeof_field(struct ceph_mds_request_head, nu=
m_fwd);
> -               max =3D 1 << (max * BITS_PER_BYTE);
> -               if (req->r_num_fwd >=3D max) {
> -                       mutex_lock(&req->r_fill_mutex);
> -                       req->r_err =3D -EMULTIHOP;
> -                       set_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags);
> -                       mutex_unlock(&req->r_fill_mutex);
> -                       aborted =3D true;
> -                       pr_warn_ratelimited_client(cl,
> -                                       "forward tid %llu seq overflow\n"=
,
> -                                       tid);
> -               } else {
> -                       doutc(cl, "forward tid %llu to mds%d - old seq %d=
 <=3D %d\n",
> -                             tid, next_mds, req->r_num_fwd, fwd_seq);
> -               }
> +               mutex_lock(&req->r_fill_mutex);
> +               req->r_err =3D -EMULTIHOP;
> +               set_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags);
> +               mutex_unlock(&req->r_fill_mutex);
> +               aborted =3D true;
> +               pr_warn_ratelimited_client(cl, "forward tid %llu seq over=
flow\n", tid);
>         } else {
>                 /* resend. forward race not possible; mds would drop */
>                 doutc(cl, "forward tid %llu to mds%d (we resend)\n", tid,=
 next_mds);
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index befbd384428e..717a7399bacb 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -32,8 +32,9 @@ enum ceph_feature_type {
>         CEPHFS_FEATURE_ALTERNATE_NAME,
>         CEPHFS_FEATURE_NOTIFY_SESSION_STATE,
>         CEPHFS_FEATURE_OP_GETVXATTR,
> +       CEPHFS_FEATURE_32BITS_RETRY_FWD,
>
> -       CEPHFS_FEATURE_MAX =3D CEPHFS_FEATURE_OP_GETVXATTR,
> +       CEPHFS_FEATURE_MAX =3D CEPHFS_FEATURE_32BITS_RETRY_FWD,
>  };
>
>  #define CEPHFS_FEATURES_CLIENT_SUPPORTED {     \
> @@ -47,6 +48,7 @@ enum ceph_feature_type {
>         CEPHFS_FEATURE_ALTERNATE_NAME,          \
>         CEPHFS_FEATURE_NOTIFY_SESSION_STATE,    \
>         CEPHFS_FEATURE_OP_GETVXATTR,            \
> +       CEPHFS_FEATURE_32BITS_RETRY_FWD,        \
>  }
>
>  /*
> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> index 45f8ce61e103..f3b3593254b9 100644
> --- a/include/linux/ceph/ceph_fs.h
> +++ b/include/linux/ceph/ceph_fs.h
> @@ -484,7 +484,7 @@ union ceph_mds_request_args_ext {
>  #define CEPH_MDS_FLAG_WANT_DENTRY      2 /* want dentry in reply */
>  #define CEPH_MDS_FLAG_ASYNC            4 /* request is asynchronous */
>
> -struct ceph_mds_request_head_old {
> +struct ceph_mds_request_head_legacy {
>         __le64 oldest_client_tid;
>         __le32 mdsmap_epoch;           /* on client */
>         __le32 flags;                  /* CEPH_MDS_FLAG_* */
> @@ -497,9 +497,9 @@ struct ceph_mds_request_head_old {
>         union ceph_mds_request_args args;
>  } __attribute__ ((packed));
>
> -#define CEPH_MDS_REQUEST_HEAD_VERSION  1
> +#define CEPH_MDS_REQUEST_HEAD_VERSION  2
>
> -struct ceph_mds_request_head {
> +struct ceph_mds_request_head_old {
>         __le16 version;                /* struct version */
>         __le64 oldest_client_tid;
>         __le32 mdsmap_epoch;           /* on client */
> @@ -513,6 +513,23 @@ struct ceph_mds_request_head {
>         union ceph_mds_request_args_ext args;
>  } __attribute__ ((packed));
>
> +struct ceph_mds_request_head {
> +       __le16 version;                /* struct version */
> +       __le64 oldest_client_tid;
> +       __le32 mdsmap_epoch;           /* on client */
> +       __le32 flags;                  /* CEPH_MDS_FLAG_* */
> +       __u8 num_retry, num_fwd;       /* legacy count retry and fwd atte=
mpts */
> +       __le16 num_releases;           /* # include cap/lease release rec=
ords */
> +       __le32 op;                     /* mds op code */
> +       __le32 caller_uid, caller_gid;
> +       __le64 ino;                    /* use this ino for openc, mkdir, =
mknod,
> +                                         etc. (if replaying) */
> +       union ceph_mds_request_args_ext args;
> +
> +       __le32 ext_num_retry;          /* new count retry attempts */
> +       __le32 ext_num_fwd;            /* new count fwd attempts */
> +} __attribute__ ((packed));
> +
>  /* cap/lease release record */
>  struct ceph_mds_request_release {
>         __le64 ino, cap_id;            /* ino and unique cap id */
> --
> 2.40.1
>
