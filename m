Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B735A48ABA
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jun 2019 19:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfFQRpB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Jun 2019 13:45:01 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:33259 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfFQRpA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 17 Jun 2019 13:45:00 -0400
Received: by mail-ua1-f66.google.com with SMTP id f20so3825613ual.0
        for <ceph-devel@vger.kernel.org>; Mon, 17 Jun 2019 10:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RQVypkeP3bteLvAHBtEruV2XrMPuc9mG8LSgNWFy2y8=;
        b=Cq9X2iYWcAR0t/C24QH+KKDE2G+qL4NH/ikHdhHbufaeJMk31B+QANoNR8k5vOzH3g
         bo7UufbDtF3f7Gv/L8ucR5jHQwUdUMWH29iuhtnf7du6VYzKVqnF64LC5DcYgvrER2gF
         uFAQNy3G3Lyh1oNe5Na0eWw6vodUSyFUgosKmobTEdcfMXlk22BaWZRjN6j5N85kygth
         aAo1XRw8BPap0TD6QbnEj/X5VR9Z7ykOGCgzTO1FOHI7kGSxEu+k7wXdnQEK7qScLywl
         G+mjbDbFdrjEYq7GXDgQW9RYDND2vwscr3AwLP37vH6jSsRHDE9PPC0Arq0Ty15nBAgD
         UgaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RQVypkeP3bteLvAHBtEruV2XrMPuc9mG8LSgNWFy2y8=;
        b=a79wgmforWqv/9fr9qsqPubbQKBeS1qPfbJ3X2ER3h6bcmIsKU2MC3jJmsE59ktszc
         muAk+f/S9FqPdTbZ7FcUC0dmzeWwV8DiUxqsoVquX7VURZjm5/xOxFH2OdUErw2CosFY
         BD6J9fVznIFTkdoLKRMKcAbQxERqA76/kzhQJQZi+CTzPgLcgkyTc/VKdjtiygZCDBkw
         Qk70FnLyFzuFTzLO9qd+glLcHmM3i18PnGFKO9KqTG0A0mbAadqCFanEXgfsudg9EpOB
         SeYD5XCZ4PgDKbpgEUd83IAGzJf/JpMMNMpo2NWnpdS3OzkbKSIAX/3BmV6+NZ+RU1hL
         h2iA==
X-Gm-Message-State: APjAAAXyEteBCzQMQTp0mlFOafAgebY9Bg16a0BUKjHKWn8+bzkBBR3d
        6Te0stj2ZYk+oKATN35wcDKouyA6uoJ0p8MRJIiCJB34
X-Google-Smtp-Source: APXvYqxtbSPm/my+xeNspeH+UWdC0EK9IJXHVnljGz6Qkg8bAGDm6OGWD0fSU4hBW9Pj+b6TvUk82LFqEaoqttsrZxo=
X-Received: by 2002:a9f:2e0e:: with SMTP id t14mr16387055uaj.119.1560793499317;
 Mon, 17 Jun 2019 10:44:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190617125529.6230-1-zyan@redhat.com> <20190617125529.6230-5-zyan@redhat.com>
 <86f838f18f0871d6c21ae7bfb97541f1de8d918f.camel@redhat.com>
In-Reply-To: <86f838f18f0871d6c21ae7bfb97541f1de8d918f.camel@redhat.com>
From:   Huang Zhiteng <winston.d@gmail.com>
Date:   Tue, 18 Jun 2019 01:44:47 +0800
Message-ID: <CAE7zfpMH8sviX761zngrdJROjS=9dbU46x_aOnmbSZyOkqqALQ@mail.gmail.com>
Subject: Re: [PATCH 4/8] ceph: allow remounting aborted mount
To:     Jeff Layton <jlayton@redhat.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>, idryomov@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 18, 2019 at 1:30 AM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Mon, 2019-06-17 at 20:55 +0800, Yan, Zheng wrote:
> > When remounting aborted mount, also reset client's entity addr.
> > 'umount -f /ceph; mount -o remount /ceph' can be used for recovering
> > from blacklist.
> >
>
> Why do I need to umount here? Once the filesystem is unmounted, then the
> '-o remount' becomes superfluous, no? In fact, I get an error back when
> I try to remount an unmounted filesystem:
>
>     $ sudo umount -f /mnt/cephfs ; sudo mount -o remount /mnt/cephfs
>     mount: /mnt/cephfs: mount point not mounted or bad option.
>
> My client isn't blacklisted above, so I guess you're counting on the
> umount returning without having actually unmounted the filesystem?
>
> I think this ought to not need a umount first. From a UI standpoint,
> just doing a "mount -o remount" ought to be sufficient to clear this.
>
> Also, how would an admin know that this is something they ought to try?
> Is there a way for them to know that their client has been blacklisted?
In our deployment, we actually capture the blacklist event and convert
that to a customer facing event to let them know their client(s) has
been blacklisted.  Upon receiving such notification, they can
reconnect clients to MDS and minimize the down time.
>
> > Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> > ---
> >  fs/ceph/mds_client.c | 16 +++++++++++++---
> >  fs/ceph/super.c      | 23 +++++++++++++++++++++--
> >  2 files changed, 34 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 19c62cf7d5b8..188c33709d9a 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -1378,9 +1378,12 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
> >               struct ceph_cap_flush *cf;
> >               struct ceph_mds_client *mdsc = fsc->mdsc;
> >
> > -             if (ci->i_wrbuffer_ref > 0 &&
> > -                 READ_ONCE(fsc->mount_state) == CEPH_MOUNT_SHUTDOWN)
> > -                     invalidate = true;
> > +             if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_SHUTDOWN) {
> > +                     if (inode->i_data.nrpages > 0)
> > +                             invalidate = true;
> > +                     if (ci->i_wrbuffer_ref > 0)
> > +                             mapping_set_error(&inode->i_data, -EIO);
> > +             }
> >
> >               while (!list_empty(&ci->i_cap_flush_list)) {
> >                       cf = list_first_entry(&ci->i_cap_flush_list,
> > @@ -4350,7 +4353,12 @@ void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
> >               session = __ceph_lookup_mds_session(mdsc, mds);
> >               if (!session)
> >                       continue;
> > +
> > +             if (session->s_state == CEPH_MDS_SESSION_REJECTED)
> > +                     __unregister_session(mdsc, session);
> > +             __wake_requests(mdsc, &session->s_waiting);
> >               mutex_unlock(&mdsc->mutex);
> > +
> >               mutex_lock(&session->s_mutex);
> >               __close_session(mdsc, session);
> >               if (session->s_state == CEPH_MDS_SESSION_CLOSING) {
> > @@ -4359,9 +4367,11 @@ void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
> >               }
> >               mutex_unlock(&session->s_mutex);
> >               ceph_put_mds_session(session);
> > +
> >               mutex_lock(&mdsc->mutex);
> >               kick_requests(mdsc, mds);
> >       }
> > +
> >       __wake_requests(mdsc, &mdsc->waiting_for_map);
> >       mutex_unlock(&mdsc->mutex);
> >  }
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index 67eb9d592ab7..a6a3c065f697 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -833,8 +833,27 @@ static void ceph_umount_begin(struct super_block *sb)
> >
> >  static int ceph_remount(struct super_block *sb, int *flags, char *data)
> >  {
> > -     sync_filesystem(sb);
> > -     return 0;
> > +     struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
> > +
> > +     if (fsc->mount_state != CEPH_MOUNT_SHUTDOWN) {
> > +             sync_filesystem(sb);
> > +             return 0;
> > +     }
> > +
> > +     /* Make sure all page caches get invalidated.
> > +      * see remove_session_caps_cb() */
> > +     flush_workqueue(fsc->inode_wq);
> > +     /* In case that we were blacklisted. This also reset
> > +      * all mon/osd connections */
> > +     ceph_reset_client_addr(fsc->client);
> > +
> > +     ceph_osdc_clear_abort_err(&fsc->client->osdc);
> > +     fsc->mount_state = 0;
> > +
> > +     if (!sb->s_root)
> > +             return 0;
> > +     return __ceph_do_getattr(d_inode(sb->s_root), NULL,
> > +                              CEPH_STAT_CAP_INODE, true);
> >  }
> >
> >  static const struct super_operations ceph_super_ops = {
>
> --
> Jeff Layton <jlayton@redhat.com>
>


-- 
Regards
Huang Zhiteng
