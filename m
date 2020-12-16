Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7974A2DC816
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Dec 2020 22:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbgLPVAc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Dec 2020 16:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727000AbgLPVAc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 16 Dec 2020 16:00:32 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBBFEC06179C
        for <ceph-devel@vger.kernel.org>; Wed, 16 Dec 2020 12:59:51 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id n9so12903993ili.0
        for <ceph-devel@vger.kernel.org>; Wed, 16 Dec 2020 12:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dAvRDJjkRgb2ghbXunAN8OHPqQOfHBhx4iAhyR9GMXI=;
        b=uO6V61l9aE9tqDuya36fJKc2rhAwo00GTyfS1Q9iWUKWZ/iTGbCueUyI48p7WQYbjK
         l/FkeJDza6vxj12/IWeVNxlZtV1jDsPcSKk2TgWUGRtyE67Aujdlw5UaQbES4/qvexVb
         eKxPuNFmCDWqX/ZI0JdgpKSKZ4UwtrpVj8ovxFwTRvbKuIwiITW/Cqx8aRIHOATUrAJM
         T5ZXZ5s4PeaVlAeQ4tVHwdQqQULkZN/3Vutp0MC+Uf4Fk4ohsHi/zxhaPLr3Qejw7C/G
         j3U/uQ5NY0R6sciiIyF6xvGzaSm1WIbaWu1x4xwaLyvE8wtMWF+i8WfIyNEdSlBX5MDa
         1OyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dAvRDJjkRgb2ghbXunAN8OHPqQOfHBhx4iAhyR9GMXI=;
        b=qYlF720WaRBkXwTvSNGICZxe/Jyb9g4hYHxMcx8HUPGOr0bwDRohXKxaQZveWi4pn3
         98D+VitcABeJmGKv5Y1gFHbBfzntmk9/YLRFB7aJW/ePSLgdeIsD60QNomc/nrO/lDra
         rdnImYts4H6BVYa5f5rqKQK+DUM6/SeRu+dVugyg6XGi6K1Vgu3op3Bm2Atlk6/Lcz9W
         ncnEatCt3Y7gIBjg6z3Oj3szBIsXMZ1tndHq2RbAagH0B/p+L3PTwNtbnF5RLYyvBr+N
         N57XC32O90nMfpf3Ni8teOZKEUE45v8aEeO2uYHAcb/L5Ug8x4L501xNe7SuB+1Zrrj/
         vigg==
X-Gm-Message-State: AOAM530dJWfRX+pr0i0EqKcV5205hEa6Z/hoRt0iDxfr0rpiS079bV76
        WT8+vfwFnKmXjFbFaTf53XtjnTA5Fbm7L/5+EDs=
X-Google-Smtp-Source: ABdhPJzuL0hTBO3Ze0kHfgAK5tEOLJbFhXzTqdMUHebsuGdravR6AlYH0K+oQVyhLLYu2ONUm11n0g727L4WRFz03RI=
X-Received: by 2002:a92:4c3:: with SMTP id 186mr48125752ile.177.1608152391105;
 Wed, 16 Dec 2020 12:59:51 -0800 (PST)
MIME-Version: 1.0
References: <20201216195043.385741-1-jlayton@kernel.org> <CAOi1vP_rcAgNO2r+D9bVy4TUtmEpsTWsP7WGnEfSsMdSsjJRhA@mail.gmail.com>
In-Reply-To: <CAOi1vP_rcAgNO2r+D9bVy4TUtmEpsTWsP7WGnEfSsMdSsjJRhA@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 16 Dec 2020 21:59:38 +0100
Message-ID: <CAOi1vP_sFErtU3BW6R5AGy=69Egt1tsjr_GNthpHwZ9_V1rSQg@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: implement updated ceph_mds_request_head structure
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Xiubo Li <xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Dec 16, 2020 at 9:16 PM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Wed, Dec 16, 2020 at 8:50 PM Jeff Layton <jlayton@kernel.org> wrote:
> >
> > When we added the btime feature in mainline ceph, we had to extend
> > struct ceph_mds_request_args so that it could be set. Implement the same
> > in the kernel client.
> >
> > Rename ceph_mds_request_head with a _old extension, and a union
> > ceph_mds_request_args_ext to allow for the extended size of the new
> > header format.
> >
> > Add the appropriate code to handle both formats in struct
> > create_request_message and key the behavior on whether the peer supports
> > CEPH_FEATURE_FS_BTIME.
> >
> > The gid_list field in the payload is now populated from the saved
> > credential. For now, we don't add any support for setting the btime via
> > setattr, but this does enable us to add that in the future.
> >
> > [ idryomov: break unnecessarily long lines ]
> >
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/mds_client.c         | 101 ++++++++++++++++++++++++++---------
> >  include/linux/ceph/ceph_fs.h |  32 ++++++++++-
> >  2 files changed, 108 insertions(+), 25 deletions(-)
> >
> >  v2: fix encoding of unsafe request resends
> >      add encode_payload_tail helper
> >      rework find_old_request_head to take a "legacy" flag argument
> >
> > Ilya,
> >
> > I'll go ahead and merge this into testing, but your call on whether we
> > should take this for v5.11, or wait for v5.12. We don't have anything
> > blocked on this just yet.
> >
> > I dropped your SoB and Xiubo Reviewed-by tags as well, as the patch is
> > a bit different from the original.
> >
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 0ff76f21466a..cd0cc5d8c4f0 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -2475,15 +2475,46 @@ static int set_request_path_attr(struct inode *rinode, struct dentry *rdentry,
> >         return r;
> >  }
> >
> > +static struct ceph_mds_request_head_old *
> > +find_old_request_head(void *p, bool legacy)
> > +{
> > +       struct ceph_mds_request_head *new_head;
> > +
> > +       if (legacy)
> > +               return (struct ceph_mds_request_head_old *)p;
> > +       new_head = (struct ceph_mds_request_head *)p;
> > +       return (struct ceph_mds_request_head_old *)&new_head->oldest_client_tid;
> > +}
> > +
> > +static void encode_payload_tail(void **p, struct ceph_mds_request *req, bool legacy)
> > +{
> > +       struct ceph_timespec ts;
> > +
> > +       ceph_encode_timespec64(&ts, &req->r_stamp);
> > +       ceph_encode_copy(p, &ts, sizeof(ts));
> > +
> > +       /* gid list */
> > +       if (!legacy) {
> > +               int i;
> > +
> > +               ceph_encode_32(p, req->r_cred->group_info->ngroups);
> > +               for (i = 0; i < req->r_cred->group_info->ngroups; i++)
> > +                       ceph_encode_64(p, from_kgid(&init_user_ns,
> > +                                      req->r_cred->group_info->gid[i]));
> > +       }
> > +}
> > +
> >  /*
> >   * called under mdsc->mutex
> >   */
> > -static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
> > +static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
> >                                                struct ceph_mds_request *req,
> > -                                              int mds, bool drop_cap_releases)
> > +                                              bool drop_cap_releases)
> >  {
> > +       int mds = session->s_mds;
> > +       struct ceph_mds_client *mdsc = session->s_mdsc;
> >         struct ceph_msg *msg;
> > -       struct ceph_mds_request_head *head;
> > +       struct ceph_mds_request_head_old *head;
> >         const char *path1 = NULL;
> >         const char *path2 = NULL;
> >         u64 ino1 = 0, ino2 = 0;
> > @@ -2493,6 +2524,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
> >         u16 releases;
> >         void *p, *end;
> >         int ret;
> > +       bool legacy = !(session->s_con.peer_features & CEPH_FEATURE_FS_BTIME);
> >
> >         ret = set_request_path_attr(req->r_inode, req->r_dentry,
> >                               req->r_parent, req->r_path1, req->r_ino1.ino,
> > @@ -2514,14 +2546,23 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
> >                 goto out_free1;
> >         }
> >
> > -       len = sizeof(*head) +
> > -               pathlen1 + pathlen2 + 2*(1 + sizeof(u32) + sizeof(u64)) +
> > +       if (legacy) {
> > +               /* Old style */
> > +               len = sizeof(*head);
> > +       } else {
> > +               /* New style: add gid_list and any later fields */
> > +               len = sizeof(struct ceph_mds_request_head) + sizeof(u32) +
> > +                     (sizeof(u64) * req->r_cred->group_info->ngroups);
> > +       }
> > +
> > +       len += pathlen1 + pathlen2 + 2*(1 + sizeof(u32) + sizeof(u64)) +
> >                 sizeof(struct ceph_timespec);
> >
> >         /* calculate (max) length for cap releases */
> >         len += sizeof(struct ceph_mds_request_release) *
> >                 (!!req->r_inode_drop + !!req->r_dentry_drop +
> >                  !!req->r_old_inode_drop + !!req->r_old_dentry_drop);
> > +
> >         if (req->r_dentry_drop)
> >                 len += pathlen1;
> >         if (req->r_old_dentry_drop)
> > @@ -2533,11 +2574,25 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
> >                 goto out_free2;
> >         }
> >
> > -       msg->hdr.version = cpu_to_le16(3);
> >         msg->hdr.tid = cpu_to_le64(req->r_tid);
> >
> > -       head = msg->front.iov_base;
> > -       p = msg->front.iov_base + sizeof(*head);
> > +       /*
> > +        * The old ceph_mds_request_header didn't contain a version field, and
> > +        * one was added when we moved the message version from 3->4.
> > +        */
> > +       if (legacy) {
> > +               msg->hdr.version = cpu_to_le16(3);
> > +               p = msg->front.iov_base + sizeof(*head);
> > +       } else {
> > +               struct ceph_mds_request_head *new_head = msg->front.iov_base;
> > +
> > +               msg->hdr.version = cpu_to_le16(4);
> > +               new_head->version = cpu_to_le16(CEPH_MDS_REQUEST_HEAD_VERSION);
> > +               p = msg->front.iov_base + sizeof(*new_head);
> > +       }
> > +
> > +       head = find_old_request_head(msg->front.iov_base, legacy);
> > +
> >         end = msg->front.iov_base + msg->front.iov_len;
> >
> >         head->mdsmap_epoch = cpu_to_le32(mdsc->mdsmap->m_epoch);
> > @@ -2583,12 +2638,7 @@ static struct ceph_msg *create_request_message(struct ceph_mds_client *mdsc,
> >
> >         head->num_releases = cpu_to_le16(releases);
> >
> > -       /* time stamp */
> > -       {
> > -               struct ceph_timespec ts;
> > -               ceph_encode_timespec64(&ts, &req->r_stamp);
> > -               ceph_encode_copy(&p, &ts, sizeof(ts));
> > -       }
> > +       encode_payload_tail(&p, req, legacy);
> >
> >         if (WARN_ON_ONCE(p > end)) {
> >                 ceph_msg_put(msg);
> > @@ -2642,9 +2692,10 @@ static int __prepare_send_request(struct ceph_mds_session *session,
> >  {
> >         int mds = session->s_mds;
> >         struct ceph_mds_client *mdsc = session->s_mdsc;
> > -       struct ceph_mds_request_head *rhead;
> > +       struct ceph_mds_request_head_old *rhead;
> >         struct ceph_msg *msg;
> >         int flags = 0;
> > +       bool legacy = !(session->s_con.peer_features & CEPH_FEATURE_FS_BTIME);
> >
> >         req->r_attempts++;
> >         if (req->r_inode) {
> > @@ -2661,6 +2712,7 @@ static int __prepare_send_request(struct ceph_mds_session *session,
> >
> >         if (test_bit(CEPH_MDS_R_GOT_UNSAFE, &req->r_req_flags)) {
> >                 void *p;
> > +
> >                 /*
> >                  * Replay.  Do not regenerate message (and rebuild
> >                  * paths, etc.); just use the original message.
> > @@ -2668,7 +2720,7 @@ static int __prepare_send_request(struct ceph_mds_session *session,
> >                  * d_move mangles the src name.
> >                  */
> >                 msg = req->r_request;
> > -               rhead = msg->front.iov_base;
> > +               rhead = find_old_request_head(msg->front.iov_base, legacy);
> >
> >                 flags = le32_to_cpu(rhead->flags);
> >                 flags |= CEPH_MDS_FLAG_REPLAY;
> > @@ -2682,13 +2734,14 @@ static int __prepare_send_request(struct ceph_mds_session *session,
> >                 /* remove cap/dentry releases from message */
> >                 rhead->num_releases = 0;
> >
> > -               /* time stamp */
> > +               /* verify that we haven't got mixed-feature MDSs */
> > +               if (legacy)
> > +                       WARN_ON_ONCE(le16_to_cpu(msg->hdr.version) >= 4);
> > +               else
> > +                       WARN_ON_ONCE(le16_to_cpu(msg->hdr.version) < 4);
>
> As mentioned in the ticket, I already did a minimal encode_gid_list()
> helper -- just haven't pushed because I had to leave.  Looking at this,
> I not clear on why even bother with v3 vs v4 and the legacy branch.
> The only that is conditional on CEPH_FEATURE_FS_BTIME is the head, we
> can encode gids and set the version to 4 unconditionally.

Sorry, what I meant is we can encode gids unconditionally, without
regard to what head/which version was used as a result of checking
whether CEPH_FEATURE_FS_BTIME is supported by the MDS.

Thanks,

                Ilya
