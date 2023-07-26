Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77BDB76375D
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jul 2023 15:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbjGZNUO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Jul 2023 09:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjGZNUM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Jul 2023 09:20:12 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFB5128
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jul 2023 06:20:10 -0700 (PDT)
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com [209.85.128.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 254C4413BE
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jul 2023 13:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1690377608;
        bh=QpGQxjBbUV/KeikUpi0x021wluP+vHn6Jo/ceeZ9RiA=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=Tg0yppL+wN31RM6XFc5FRFT5EciogUmBAQVEADpdxU5oSBEWqHhcUQtTIk+qRd1+g
         biAwk7N0cL3Z4qjlNe5si+uJ23foSAnlIqfgDwn1JKR8jaC4/I9BEs6qjIci1TLakO
         SOOLlZaYngOlxQdbPTWWELHfhqvrbJvW9MR6QAtzI35BqfqCaOvJa9oBm1pa53aI0h
         YHCGHys5k1oSWi4lxIMDbVpMyvD21Fck5FuBm1RbAuvm9TLS1JjQxOnACEbEi5MBj5
         gV3xOGrTeqjqtTw+rmX0+tVRsEUyMQ51zBl/V+OiGYKOB5lGcL+5dlP+8x3EHB4zIy
         7ypt1ulyQujyA==
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-583a4015791so55281437b3.1
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jul 2023 06:20:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690377607; x=1690982407;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QpGQxjBbUV/KeikUpi0x021wluP+vHn6Jo/ceeZ9RiA=;
        b=jQ9kApymYQW2UGUr4K1kKQ3IFDigC0s5w4VoIkhcvfT9FSiTXptaX2wZKXD/S476gg
         BA+Y+ldD9+YB/0LXOg28iv5vCOAbSOe62XE4nxna7Zqc2sY86RdorWBzAPquZCtFPRf2
         lfN+E79SzzL5zid8/I0+8p5KfvLZZH8QZ4jfWR5JID+CEjaccXk/P2aH4MfV2829VQGV
         Mp+JUC6Slo8P+mHQINPCVoNvJYm4utiBTDc4Q039B4juX9hYPVDgMy2stBCheG+jOzQ5
         boA1MhntIry53ApZ8atS4vHJmzo9vZI104loBUHDp2teiaO0SkmzkcvoIT7xWTtPxnM5
         8PEA==
X-Gm-Message-State: ABy/qLbQk5hdQSxLyYzaj+M+VCqPNI7Z5hhARNYUTLvvMfKttKvoGcl7
        M9W+HKQRYD+nEW+SDtkzGzPXie3Ng892IYSrWDw2e3pSYaKWNNpRsesSKueNneadw9/6EIEjoWc
        8lEfPAiZCdP9XhFOFThoB/yeQnEqxXZXND5mmSWCHEY9/5om+ZJ2fYIs=
X-Received: by 2002:a81:9115:0:b0:56d:244:ab13 with SMTP id i21-20020a819115000000b0056d0244ab13mr2067681ywg.28.1690377607061;
        Wed, 26 Jul 2023 06:20:07 -0700 (PDT)
X-Google-Smtp-Source: APBJJlG9vS7vYbhvvJG4223llfmF1/+hNpF4eb4CDnfEvR1VDOJRxT56SWhNy+9g6zDJgecID/CjPrMkUUA3Ehs26Qg=
X-Received: by 2002:a81:9115:0:b0:56d:244:ab13 with SMTP id
 i21-20020a819115000000b0056d0244ab13mr2067657ywg.28.1690377606731; Wed, 26
 Jul 2023 06:20:06 -0700 (PDT)
MIME-Version: 1.0
References: <20230725104438.386461-1-xiubli@redhat.com> <CAEivzxfsi8e3CjYhT5SHOog6TPNsWga6nWNvwQduzJHnL-Bdxw@mail.gmail.com>
 <0828aa69-aeaf-e423-be6f-8c59a3c9755b@redhat.com>
In-Reply-To: <0828aa69-aeaf-e423-be6f-8c59a3c9755b@redhat.com>
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Wed, 26 Jul 2023 15:19:55 +0200
Message-ID: <CAEivzxe_RSR3cAu4C9Zjq=pW7PATXkX_CBvFuemNhOFVX8_ceg@mail.gmail.com>
Subject: Re: [PATCH] ceph: make num_fwd and num_retry to __u32
To:     Xiubo Li <xiubli@redhat.com>
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

On Wed, Jul 26, 2023 at 3:16=E2=80=AFPM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 7/26/23 18:06, Aleksandr Mikhalitsyn wrote:
> > Hi Xiubo!
> >
> > On Tue, Jul 25, 2023 at 12:46=E2=80=AFPM <xiubli@redhat.com> wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> The num_fwd in MClientRequestForward is int32_t, while the num_fwd
> >> in ceph_mds_request_head is __u8. This is buggy when the num_fwd
> >> is larger than 256 it will always be truncate to 0 again. But the
> >> client couldn't recoginize this.
> >>
> >> This will make them to __u32 instead. Because the old cephs will
> >> directly copy the raw memories when decoding the reqeust's head,
> >> so we need to make sure this kclient will be compatible with old
> >> cephs. For newer cephs they will decode the requests depending
> >> the version, which will be much simpler and easier to extend new
> >> members.
> >>
> >> URL: https://tracker.ceph.com/issues/62145
> >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >> ---
> >>   fs/ceph/mds_client.c         | 191 ++++++++++++++++++---------------=
--
> >>   fs/ceph/mds_client.h         |   4 +-
> >>   include/linux/ceph/ceph_fs.h |  23 ++++-
> >>   3 files changed, 124 insertions(+), 94 deletions(-)
> >>
> >> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> >> index 70987b3c198a..191bae3a4ee6 100644
> >> --- a/fs/ceph/mds_client.c
> >> +++ b/fs/ceph/mds_client.c
> >> @@ -2897,6 +2897,18 @@ static void encode_mclientrequest_tail(void **p=
, const struct ceph_mds_request *
> >>          }
> >>   }
> >>
> >> +static struct ceph_mds_request_head_legacy *
> >> +find_legacy_request_head(void *p, u64 features)
> >> +{
> >> +       bool legacy =3D !(features & CEPH_FEATURE_FS_BTIME);
> >> +       struct ceph_mds_request_head_old *ohead;
> >> +
> >> +       if (legacy)
> >> +               return (struct ceph_mds_request_head_legacy *)p;
> >> +       ohead =3D (struct ceph_mds_request_head_old *)p;
> >> +       return (struct ceph_mds_request_head_legacy *)&ohead->oldest_c=
lient_tid;
> >> +}
> >> +
> >>   /*
> >>    * called under mdsc->mutex
> >>    */
> >> @@ -2907,7 +2919,7 @@ static struct ceph_msg *create_request_message(s=
truct ceph_mds_session *session,
> >>          int mds =3D session->s_mds;
> >>          struct ceph_mds_client *mdsc =3D session->s_mdsc;
> >>          struct ceph_msg *msg;
> >> -       struct ceph_mds_request_head_old *head;
> >> +       struct ceph_mds_request_head_legacy *lhead;
> >>          const char *path1 =3D NULL;
> >>          const char *path2 =3D NULL;
> >>          u64 ino1 =3D 0, ino2 =3D 0;
> >> @@ -2919,6 +2931,7 @@ static struct ceph_msg *create_request_message(s=
truct ceph_mds_session *session,
> >>          void *p, *end;
> >>          int ret;
> >>          bool legacy =3D !(session->s_con.peer_features & CEPH_FEATURE=
_FS_BTIME);
> >> +       bool old_version =3D !test_bit(CEPHFS_FEATURE_32BITS_RETRY_FWD=
, &session->s_features);
> >>
> >>          ret =3D set_request_path_attr(mdsc, req->r_inode, req->r_dent=
ry,
> >>                                req->r_parent, req->r_path1, req->r_ino=
1.ino,
> >> @@ -2950,7 +2963,19 @@ static struct ceph_msg *create_request_message(=
struct ceph_mds_session *session,
> >>                  goto out_free2;
> >>          }
> >>
> >> -       len =3D legacy ? sizeof(*head) : sizeof(struct ceph_mds_reques=
t_head);
> >> +       /*
> >> +        * For old cephs without supporting the 32bit retry/fwd featur=
e
> >> +        * it will copy the raw memories directly when decoding the
> >> +        * requests. While new cephs will decode the head depending th=
e
> >> +        * version member, so we need to make sure it will be compatib=
le
> >> +        * with them both.
> >> +        */
> >> +       if (legacy)
> >> +               len =3D sizeof(struct ceph_mds_request_head_legacy);
> >> +       else if (old_version)
> >> +               len =3D sizeof(struct ceph_mds_request_head_old);
> >> +       else
> >> +               len =3D sizeof(struct ceph_mds_request_head);
> >>
> >>          /* filepaths */
> >>          len +=3D 2 * (1 + sizeof(u32) + sizeof(u64));
> >> @@ -2995,33 +3020,40 @@ static struct ceph_msg *create_request_message=
(struct ceph_mds_session *session,
> >>
> >>          msg->hdr.tid =3D cpu_to_le64(req->r_tid);
> >>
> >> +       lhead =3D find_legacy_request_head(msg->front.iov_base,
> >> +                                        session->s_con.peer_features)=
;
> >> +
> >>          /*
> >> -        * The old ceph_mds_request_head didn't contain a version fiel=
d, and
> >> +        * The ceph_mds_request_head_legacy didn't contain a version f=
ield, and
> >>           * one was added when we moved the message version from 3->4.
> >>           */
> >>          if (legacy) {
> >>                  msg->hdr.version =3D cpu_to_le16(3);
> >> -               head =3D msg->front.iov_base;
> >> -               p =3D msg->front.iov_base + sizeof(*head);
> >> +               p =3D msg->front.iov_base + sizeof(*lhead);
> >> +       } else if (old_version) {
> >> +               struct ceph_mds_request_head_old *ohead =3D msg->front=
.iov_base;
> >> +
> >> +               msg->hdr.version =3D cpu_to_le16(4);
> >> +               ohead->version =3D cpu_to_le16(CEPH_MDS_REQUEST_HEAD_V=
ERSION);
> > Don't we want to use the old mds request head version here:
> > ohead->version =3D cpu_to_le16(1);
> > ?
> >
> > As far as I understand the idea here is to skip new fields
> > ext_num_retry/ext_num_fwd in case
> > when the old_version is true. Would it be incorrect to set version to
> > the latest one (CEPH_MDS_REQUEST_HEAD_VERSION)
> > and at the same time skip the setting of new fields?
>
> Hi Alex,
>
> I noticed that, but this doesn't matter, because for the old version
> cephs they will do nothing with the version field. I am just following
> the user space code.

Got it. Thanks!

Reviewed-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>

>
> But to make the code to be more readable and easier to understand I will
> revise this. And also will raise one PR to fix the user space code.
>
> Thanks
>
> - Xiubo
>
>
> > Kind regards,
> > Alex
> >
> >> +               p =3D msg->front.iov_base + sizeof(*ohead);
> >>          } else {
> >> -               struct ceph_mds_request_head *new_head =3D msg->front.=
iov_base;
> >> +               struct ceph_mds_request_head *nhead =3D msg->front.iov=
_base;
> >>
> >>                  msg->hdr.version =3D cpu_to_le16(6);
> >> -               new_head->version =3D cpu_to_le16(CEPH_MDS_REQUEST_HEA=
D_VERSION);
> >> -               head =3D (struct ceph_mds_request_head_old *)&new_head=
->oldest_client_tid;
> >> -               p =3D msg->front.iov_base + sizeof(*new_head);
> >> +               nhead->version =3D cpu_to_le16(CEPH_MDS_REQUEST_HEAD_V=
ERSION);
> >> +               p =3D msg->front.iov_base + sizeof(*nhead);
> >>          }
> >>
> >>          end =3D msg->front.iov_base + msg->front.iov_len;
> >>
> >> -       head->mdsmap_epoch =3D cpu_to_le32(mdsc->mdsmap->m_epoch);
> >> -       head->op =3D cpu_to_le32(req->r_op);
> >> -       head->caller_uid =3D cpu_to_le32(from_kuid(&init_user_ns,
> >> -                                                req->r_cred->fsuid));
> >> -       head->caller_gid =3D cpu_to_le32(from_kgid(&init_user_ns,
> >> -                                                req->r_cred->fsgid));
> >> -       head->ino =3D cpu_to_le64(req->r_deleg_ino);
> >> -       head->args =3D req->r_args;
> >> +       lhead->mdsmap_epoch =3D cpu_to_le32(mdsc->mdsmap->m_epoch);
> >> +       lhead->op =3D cpu_to_le32(req->r_op);
> >> +       lhead->caller_uid =3D cpu_to_le32(from_kuid(&init_user_ns,
> >> +                                                 req->r_cred->fsuid))=
;
> >> +       lhead->caller_gid =3D cpu_to_le32(from_kgid(&init_user_ns,
> >> +                                                 req->r_cred->fsgid))=
;
> >> +       lhead->ino =3D cpu_to_le64(req->r_deleg_ino);
> >> +       lhead->args =3D req->r_args;
> >>
> >>          ceph_encode_filepath(&p, end, ino1, path1);
> >>          ceph_encode_filepath(&p, end, ino2, path2);
> >> @@ -3063,7 +3095,7 @@ static struct ceph_msg *create_request_message(s=
truct ceph_mds_session *session,
> >>                  p =3D msg->front.iov_base + req->r_request_release_of=
fset;
> >>          }
> >>
> >> -       head->num_releases =3D cpu_to_le16(releases);
> >> +       lhead->num_releases =3D cpu_to_le16(releases);
> >>
> >>          encode_mclientrequest_tail(&p, req);
> >>
> >> @@ -3114,18 +3146,6 @@ static void complete_request(struct ceph_mds_cl=
ient *mdsc,
> >>          complete_all(&req->r_completion);
> >>   }
> >>
> >> -static struct ceph_mds_request_head_old *
> >> -find_old_request_head(void *p, u64 features)
> >> -{
> >> -       bool legacy =3D !(features & CEPH_FEATURE_FS_BTIME);
> >> -       struct ceph_mds_request_head *new_head;
> >> -
> >> -       if (legacy)
> >> -               return (struct ceph_mds_request_head_old *)p;
> >> -       new_head =3D (struct ceph_mds_request_head *)p;
> >> -       return (struct ceph_mds_request_head_old *)&new_head->oldest_c=
lient_tid;
> >> -}
> >> -
> >>   /*
> >>    * called under mdsc->mutex
> >>    */
> >> @@ -3136,30 +3156,26 @@ static int __prepare_send_request(struct ceph_=
mds_session *session,
> >>          int mds =3D session->s_mds;
> >>          struct ceph_mds_client *mdsc =3D session->s_mdsc;
> >>          struct ceph_client *cl =3D mdsc->fsc->client;
> >> -       struct ceph_mds_request_head_old *rhead;
> >> +       struct ceph_mds_request_head_legacy *lhead;
> >> +       struct ceph_mds_request_head *nhead;
> >>          struct ceph_msg *msg;
> >> -       int flags =3D 0, max_retry;
> >> +       int flags =3D 0, old_max_retry;
> >> +       bool old_version =3D !test_bit(CEPHFS_FEATURE_32BITS_RETRY_FWD=
, &session->s_features);
> >>
> >> -       /*
> >> -        * The type of 'r_attempts' in kernel 'ceph_mds_request'
> >> -        * is 'int', while in 'ceph_mds_request_head' the type of
> >> -        * 'num_retry' is '__u8'. So in case the request retries
> >> -        *  exceeding 256 times, the MDS will receive a incorrect
> >> -        *  retry seq.
> >> -        *
> >> -        * In this case it's ususally a bug in MDS and continue
> >> -        * retrying the request makes no sense.
> >> -        *
> >> -        * In future this could be fixed in ceph code, so avoid
> >> -        * using the hardcode here.
> >> +       /* Avoid inifinite retrying after overflow. The client will
> >> +        * increase the retry count and if the MDS is old version,
> >> +        * so we limit to retry at most 256 times.
> >>           */
> >> -       max_retry =3D sizeof_field(struct ceph_mds_request_head, num_r=
etry);
> >> -       max_retry =3D 1 << (max_retry * BITS_PER_BYTE);
> >> -       if (req->r_attempts >=3D max_retry) {
> >> -               pr_warn_ratelimited_client(cl, "request tid %llu seq o=
verflow\n",
> >> -                                          req->r_tid);
> >> -               return -EMULTIHOP;
> >> -       }
> >> +       if (req->r_attempts) {
> >> +               old_max_retry =3D sizeof_field(struct ceph_mds_request=
_head_old, num_retry);
> >> +               old_max_retry =3D 1 << (old_max_retry * BITS_PER_BYTE)=
;
> >> +               if ((old_version && req->r_attempts >=3D old_max_retry=
) ||
> >> +                   ((uint32_t)req->r_attempts >=3D U32_MAX)) {
> >> +                       pr_warn_ratelimited_client(cl, "%s request tid=
 %llu seq overflow\n",
> >> +                                                 __func__, req->r_tid=
);
> >> +                       return -EMULTIHOP;
> >> +               }
> >> +        }
> >>
> >>          req->r_attempts++;
> >>          if (req->r_inode) {
> >> @@ -3184,20 +3200,24 @@ static int __prepare_send_request(struct ceph_=
mds_session *session,
> >>                   * d_move mangles the src name.
> >>                   */
> >>                  msg =3D req->r_request;
> >> -               rhead =3D find_old_request_head(msg->front.iov_base,
> >> -                                             session->s_con.peer_feat=
ures);
> >> +               lhead =3D find_legacy_request_head(msg->front.iov_base=
,
> >> +                                                session->s_con.peer_f=
eatures);
> >>
> >> -               flags =3D le32_to_cpu(rhead->flags);
> >> +               flags =3D le32_to_cpu(lhead->flags);
> >>                  flags |=3D CEPH_MDS_FLAG_REPLAY;
> >> -               rhead->flags =3D cpu_to_le32(flags);
> >> +               lhead->flags =3D cpu_to_le32(flags);
> >>
> >>                  if (req->r_target_inode)
> >> -                       rhead->ino =3D cpu_to_le64(ceph_ino(req->r_tar=
get_inode));
> >> +                       lhead->ino =3D cpu_to_le64(ceph_ino(req->r_tar=
get_inode));
> >>
> >> -               rhead->num_retry =3D req->r_attempts - 1;
> >> +               lhead->num_retry =3D req->r_attempts - 1;
> >> +               if (!old_version) {
> >> +                       nhead =3D (struct ceph_mds_request_head*)msg->=
front.iov_base;
> >> +                       nhead->ext_num_retry =3D cpu_to_le32(req->r_at=
tempts - 1);
> >> +               }
> >>
> >>                  /* remove cap/dentry releases from message */
> >> -               rhead->num_releases =3D 0;
> >> +               lhead->num_releases =3D 0;
> >>
> >>                  p =3D msg->front.iov_base + req->r_request_release_of=
fset;
> >>                  encode_mclientrequest_tail(&p, req);
> >> @@ -3218,18 +3238,23 @@ static int __prepare_send_request(struct ceph_=
mds_session *session,
> >>          }
> >>          req->r_request =3D msg;
> >>
> >> -       rhead =3D find_old_request_head(msg->front.iov_base,
> >> -                                     session->s_con.peer_features);
> >> -       rhead->oldest_client_tid =3D cpu_to_le64(__get_oldest_tid(mdsc=
));
> >> +       lhead =3D find_legacy_request_head(msg->front.iov_base,
> >> +                                        session->s_con.peer_features)=
;
> >> +       lhead->oldest_client_tid =3D cpu_to_le64(__get_oldest_tid(mdsc=
));
> >>          if (test_bit(CEPH_MDS_R_GOT_UNSAFE, &req->r_req_flags))
> >>                  flags |=3D CEPH_MDS_FLAG_REPLAY;
> >>          if (test_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags))
> >>                  flags |=3D CEPH_MDS_FLAG_ASYNC;
> >>          if (req->r_parent)
> >>                  flags |=3D CEPH_MDS_FLAG_WANT_DENTRY;
> >> -       rhead->flags =3D cpu_to_le32(flags);
> >> -       rhead->num_fwd =3D req->r_num_fwd;
> >> -       rhead->num_retry =3D req->r_attempts - 1;
> >> +       lhead->flags =3D cpu_to_le32(flags);
> >> +       lhead->num_fwd =3D req->r_num_fwd;
> >> +       lhead->num_retry =3D req->r_attempts - 1;
> >> +       if (!old_version) {
> >> +               nhead =3D (struct ceph_mds_request_head*)msg->front.io=
v_base;
> >> +               nhead->ext_num_fwd =3D cpu_to_le32(req->r_num_fwd);
> >> +               nhead->ext_num_retry =3D cpu_to_le32(req->r_attempts -=
 1);
> >> +       }
> >>
> >>          doutc(cl, " r_parent =3D %p\n", req->r_parent);
> >>          return 0;
> >> @@ -3893,34 +3918,20 @@ static void handle_forward(struct ceph_mds_cli=
ent *mdsc,
> >>          if (test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags)) {
> >>                  doutc(cl, "forward tid %llu aborted, unregistering\n"=
, tid);
> >>                  __unregister_request(mdsc, req);
> >> -       } else if (fwd_seq <=3D req->r_num_fwd) {
> >> -               /*
> >> -                * The type of 'num_fwd' in ceph 'MClientRequestForwar=
d'
> >> -                * is 'int32_t', while in 'ceph_mds_request_head' the
> >> -                * type is '__u8'. So in case the request bounces betw=
een
> >> -                * MDSes exceeding 256 times, the client will get stuc=
k.
> >> -                *
> >> -                * In this case it's ususally a bug in MDS and continu=
e
> >> -                * bouncing the request makes no sense.
> >> +       } else if (fwd_seq <=3D req->r_num_fwd || (uint32_t)fwd_seq >=
=3D U32_MAX) {
> >> +               /* Avoid inifinite retrying after overflow.
> >>                   *
> >> -                * In future this could be fixed in ceph code, so avoi=
d
> >> -                * using the hardcode here.
> >> +                * The MDS will increase the fwd count and in client s=
ide
> >> +                * if the num_fwd is less than the one saved in reques=
t
> >> +                * that means the MDS is an old version and overflowed=
 of
> >> +                * 8 bits.
> >>                   */
> >> -               int max =3D sizeof_field(struct ceph_mds_request_head,=
 num_fwd);
> >> -               max =3D 1 << (max * BITS_PER_BYTE);
> >> -               if (req->r_num_fwd >=3D max) {
> >> -                       mutex_lock(&req->r_fill_mutex);
> >> -                       req->r_err =3D -EMULTIHOP;
> >> -                       set_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags)=
;
> >> -                       mutex_unlock(&req->r_fill_mutex);
> >> -                       aborted =3D true;
> >> -                       pr_warn_ratelimited_client(cl,
> >> -                                       "forward tid %llu seq overflow=
\n",
> >> -                                       tid);
> >> -               } else {
> >> -                       doutc(cl, "forward tid %llu to mds%d - old seq=
 %d <=3D %d\n",
> >> -                             tid, next_mds, req->r_num_fwd, fwd_seq);
> >> -               }
> >> +               mutex_lock(&req->r_fill_mutex);
> >> +               req->r_err =3D -EMULTIHOP;
> >> +               set_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags);
> >> +               mutex_unlock(&req->r_fill_mutex);
> >> +               aborted =3D true;
> >> +               pr_warn_ratelimited_client(cl, "forward tid %llu seq o=
verflow\n", tid);
> >>          } else {
> >>                  /* resend. forward race not possible; mds would drop =
*/
> >>                  doutc(cl, "forward tid %llu to mds%d (we resend)\n", =
tid, next_mds);
> >> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> >> index befbd384428e..717a7399bacb 100644
> >> --- a/fs/ceph/mds_client.h
> >> +++ b/fs/ceph/mds_client.h
> >> @@ -32,8 +32,9 @@ enum ceph_feature_type {
> >>          CEPHFS_FEATURE_ALTERNATE_NAME,
> >>          CEPHFS_FEATURE_NOTIFY_SESSION_STATE,
> >>          CEPHFS_FEATURE_OP_GETVXATTR,
> >> +       CEPHFS_FEATURE_32BITS_RETRY_FWD,
> >>
> >> -       CEPHFS_FEATURE_MAX =3D CEPHFS_FEATURE_OP_GETVXATTR,
> >> +       CEPHFS_FEATURE_MAX =3D CEPHFS_FEATURE_32BITS_RETRY_FWD,
> >>   };
> >>
> >>   #define CEPHFS_FEATURES_CLIENT_SUPPORTED {     \
> >> @@ -47,6 +48,7 @@ enum ceph_feature_type {
> >>          CEPHFS_FEATURE_ALTERNATE_NAME,          \
> >>          CEPHFS_FEATURE_NOTIFY_SESSION_STATE,    \
> >>          CEPHFS_FEATURE_OP_GETVXATTR,            \
> >> +       CEPHFS_FEATURE_32BITS_RETRY_FWD,        \
> >>   }
> >>
> >>   /*
> >> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs=
.h
> >> index 45f8ce61e103..f3b3593254b9 100644
> >> --- a/include/linux/ceph/ceph_fs.h
> >> +++ b/include/linux/ceph/ceph_fs.h
> >> @@ -484,7 +484,7 @@ union ceph_mds_request_args_ext {
> >>   #define CEPH_MDS_FLAG_WANT_DENTRY      2 /* want dentry in reply */
> >>   #define CEPH_MDS_FLAG_ASYNC            4 /* request is asynchronous =
*/
> >>
> >> -struct ceph_mds_request_head_old {
> >> +struct ceph_mds_request_head_legacy {
> >>          __le64 oldest_client_tid;
> >>          __le32 mdsmap_epoch;           /* on client */
> >>          __le32 flags;                  /* CEPH_MDS_FLAG_* */
> >> @@ -497,9 +497,9 @@ struct ceph_mds_request_head_old {
> >>          union ceph_mds_request_args args;
> >>   } __attribute__ ((packed));
> >>
> >> -#define CEPH_MDS_REQUEST_HEAD_VERSION  1
> >> +#define CEPH_MDS_REQUEST_HEAD_VERSION  2
> >>
> >> -struct ceph_mds_request_head {
> >> +struct ceph_mds_request_head_old {
> >>          __le16 version;                /* struct version */
> >>          __le64 oldest_client_tid;
> >>          __le32 mdsmap_epoch;           /* on client */
> >> @@ -513,6 +513,23 @@ struct ceph_mds_request_head {
> >>          union ceph_mds_request_args_ext args;
> >>   } __attribute__ ((packed));
> >>
> >> +struct ceph_mds_request_head {
> >> +       __le16 version;                /* struct version */
> >> +       __le64 oldest_client_tid;
> >> +       __le32 mdsmap_epoch;           /* on client */
> >> +       __le32 flags;                  /* CEPH_MDS_FLAG_* */
> >> +       __u8 num_retry, num_fwd;       /* legacy count retry and fwd a=
ttempts */
> >> +       __le16 num_releases;           /* # include cap/lease release =
records */
> >> +       __le32 op;                     /* mds op code */
> >> +       __le32 caller_uid, caller_gid;
> >> +       __le64 ino;                    /* use this ino for openc, mkdi=
r, mknod,
> >> +                                         etc. (if replaying) */
> >> +       union ceph_mds_request_args_ext args;
> >> +
> >> +       __le32 ext_num_retry;          /* new count retry attempts */
> >> +       __le32 ext_num_fwd;            /* new count fwd attempts */
> >> +} __attribute__ ((packed));
> >> +
> >>   /* cap/lease release record */
> >>   struct ceph_mds_request_release {
> >>          __le64 ino, cap_id;            /* ino and unique cap id */
> >> --
> >> 2.40.1
> >>
>
