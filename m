Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2D5AF442
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2019 04:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfIKC2H (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Sep 2019 22:28:07 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:41113 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbfIKC2G (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 10 Sep 2019 22:28:06 -0400
Received: by mail-oi1-f196.google.com with SMTP id h4so12865986oih.8
        for <ceph-devel@vger.kernel.org>; Tue, 10 Sep 2019 19:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ueG9KvLL3fkCAthn/b4YDYRZJnBip3pIKkl5cbsdQvE=;
        b=SazlB1xfwqeEHZPWRFRxYr1w+kNOgr6v4zAGPzPHHfjA607TgVbbYQsYdNpTI+QGI7
         YbzxJIbR1usgYh9Q+6Gr9W2fNMhv7A9L8QxUkeIxRS0dC73BfC3AvDvCfhw4csQ+e5zK
         iVvxbmUSuuTuHbawCcqrx52cZG1ow50dFCC9jew+nbzi+EolVtBfpmvdSHFK/ywQNJ/i
         j+/Jfw84R0SwTCMdwrKd99R8MLDLOS6+DknM8k3/jAZBGhZCTXZWZ7QdqLoObUr6vsyp
         0sC49GxxrR3w/IIdCUuMsCkEqrZDDL4k4Z7ExsYBqYcE1U4jPMeo6a0F9UAcwoNeQDg/
         J6MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ueG9KvLL3fkCAthn/b4YDYRZJnBip3pIKkl5cbsdQvE=;
        b=NphizdSQvbnAjR6vzWlXSCCs6oooii8lDF+nCCqIe00HhIc4vtmlhCqkXvdgtRbd7I
         kbJlx5ozFN+1D9l4HW//U8LUqIMDdOcCTstNyjEaxRt/KUOMLVsPEBYnmb/qL4voNqQK
         X7rtVxWTteDR52/O+5VmlxT7C67MMWj76khnLtcDSbgUTTsDzi+SYyY6og0HsRktMshl
         OOXeEeegIQucU9wL9hJnwKufEFxqVXqG+uxaTZp3GBD6VVE6I6ApSbptFCfgbYPrhmNs
         wk3F/L74OudNgKYmoZBPcgIUztZMIije8p18W5btIK30U/ytS5nHfDN7oa9CrD4m31oV
         0FDw==
X-Gm-Message-State: APjAAAXzi+/44085+zenyehOUSLWRhMA2O6uQwWTYzyoOhTr9PxB0+Mh
        dt2johkAGDquXYACILI3XcHRzLxzhf/OxGUIc8U=
X-Google-Smtp-Source: APXvYqzPVHiyhCCGUf19fzpAfZl30dTdhb3jXiDDaLD1dw8O5D2uu8abPYqQMD919N1Gz+qYQ55UXgdBBtOkytCWtgc=
X-Received: by 2002:aca:1b06:: with SMTP id b6mr2079366oib.141.1568168885411;
 Tue, 10 Sep 2019 19:28:05 -0700 (PDT)
MIME-Version: 1.0
References: <1568083391-920-1-git-send-email-simon29rock@gmail.com> <e413734270fc43cabbf9df09b0ed4bff06a96699.camel@kernel.org>
In-Reply-To: <e413734270fc43cabbf9df09b0ed4bff06a96699.camel@kernel.org>
From:   simon gao <simon29rock@gmail.com>
Date:   Wed, 11 Sep 2019 10:27:54 +0800
Message-ID: <CAGR3woW0aYOC6qtpQLOc1M4tsNkTvYFDezi+cFNM4Ay4AG=DUA@mail.gmail.com>
Subject: Re: [PATCH] ceph: add mount opt, always_auth
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Gregory Farnum <gfarnum@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

thanks

Jeff Layton <jlayton@kernel.org> =E4=BA=8E2019=E5=B9=B49=E6=9C=8810=E6=97=
=A5=E5=91=A8=E4=BA=8C =E4=B8=8B=E5=8D=886:11=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, 2019-09-09 at 22:43 -0400, simon gao wrote:
> > In larger clusters (hundreds of millions of files). We have to pin the
> > directory on a fixed mds now. Some op of client use USE_ANY_MDS mode
> > to access mds, which may result in requests being sent to noauth mds
> > and then forwarded to authmds.
> > the opt is used to reduce forward ops by sending req to auth mds.
> > ---
> >  fs/ceph/mds_client.c | 7 ++++++-
> >  fs/ceph/super.c      | 7 +++++++
> >  fs/ceph/super.h      | 1 +
> >  3 files changed, 14 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 920e9f0..aca4490 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -878,6 +878,7 @@ static struct inode *get_nonsnap_parent(struct dent=
ry *dentry)
> >  static int __choose_mds(struct ceph_mds_client *mdsc,
> >                       struct ceph_mds_request *req)
> >  {
> > +     struct ceph_mount_options *ma =3D mdsc->fsc->mount_options;
> >       struct inode *inode;
> >       struct ceph_inode_info *ci;
> >       struct ceph_cap *cap;
> > @@ -900,7 +901,11 @@ static int __choose_mds(struct ceph_mds_client *md=
sc,
> >
> >       if (mode =3D=3D USE_RANDOM_MDS)
> >               goto random;
> > -
> > +     // force to send the req to auth mds
> > +     if (ma->flags & CEPH_MOUNT_OPT_ALWAYS_AUTH && mode !=3D USE_AUTH_=
MDS){
> > +             dout("change mode %d =3D> USE_AUTH_MDS", mode);
> > +             mode =3D USE_AUTH_MDS;
> > +     }
> >       inode =3D NULL;
> >       if (req->r_inode) {
> >               if (ceph_snap(req->r_inode) !=3D CEPH_SNAPDIR) {
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index ab4868c..1e81ebc 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -169,6 +169,7 @@ enum {
> >       Opt_noquotadf,
> >       Opt_copyfrom,
> >       Opt_nocopyfrom,
> > +     Opt_always_auth,
> >  };
> >
> >  static match_table_t fsopt_tokens =3D {
> > @@ -210,6 +211,7 @@ enum {
> >       {Opt_noquotadf, "noquotadf"},
> >       {Opt_copyfrom, "copyfrom"},
> >       {Opt_nocopyfrom, "nocopyfrom"},
> > +     {Opt_always_auth, "always_auth"},
> >       {-1, NULL}
> >  };
> >
> > @@ -381,6 +383,9 @@ static int parse_fsopt_token(char *c, void *private=
)
> >       case Opt_noacl:
> >               fsopt->sb_flags &=3D ~SB_POSIXACL;
> >               break;
> > +     case Opt_always_auth:
> > +             fsopt->flags |=3D CEPH_MOUNT_OPT_ALWAYS_AUTH;
> > +             break;
> >       default:
> >               BUG_ON(token);
> >       }
> > @@ -563,6 +568,8 @@ static int ceph_show_options(struct seq_file *m, st=
ruct dentry *root)
> >               seq_puts(m, ",nopoolperm");
> >       if (fsopt->flags & CEPH_MOUNT_OPT_NOQUOTADF)
> >               seq_puts(m, ",noquotadf");
> > +     if (fsopt->flags & CEPH_MOUNT_OPT_ALWAYS_AUTH)
> > +             seq_puts(m, ",always_auth");
> >
> >  #ifdef CONFIG_CEPH_FS_POSIX_ACL
> >       if (fsopt->sb_flags & SB_POSIXACL)
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index 6b9f1ee..65f6423 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -41,6 +41,7 @@
> >  #define CEPH_MOUNT_OPT_MOUNTWAIT       (1<<12) /* mount waits if no md=
s is up */
> >  #define CEPH_MOUNT_OPT_NOQUOTADF       (1<<13) /* no root dir quota in=
 statfs */
> >  #define CEPH_MOUNT_OPT_NOCOPYFROM      (1<<14) /* don't use RADOS 'cop=
y-from' op */
> > +#define CEPH_MOUNT_OPT_ALWAYS_AUTH     (1<<15) /* send op to auth mds,=
 not to replicative mds */
> >
> >  #define CEPH_MOUNT_OPT_DEFAULT                       \
> >       (CEPH_MOUNT_OPT_DCACHE |                \
>
> I've no particular objection here, but I'd prefer Greg's ack before we
> merge it, since he raised earlier concerns.
>
> If we are going to take it, then this will need to be rebased on top of
> the mount API conversion that's currently in ceph-client/testing branch.
> --
> Jeff Layton <jlayton@kernel.org>
>
