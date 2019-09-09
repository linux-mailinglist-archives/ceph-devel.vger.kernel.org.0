Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB1DDAD231
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Sep 2019 05:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387497AbfIID33 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 8 Sep 2019 23:29:29 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:35027 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733078AbfIID33 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 8 Sep 2019 23:29:29 -0400
Received: by mail-ot1-f66.google.com with SMTP id 100so11125624otn.2
        for <ceph-devel@vger.kernel.org>; Sun, 08 Sep 2019 20:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+EIuwxQt31o5B+KbEzTlzoMjGH0U8CnFlxdqbWmSS6g=;
        b=jCYRTy4LZ25gxjGznBwgfVDF5ThslVOLXcFzUIC11Y2BlH2ohOW80xnoFf0bNk8TwD
         gj59GP+yNpI7rI0WUavCkBbDcrJMs2zHMgLbQrpfCoyQVZZfLOy9KsubTstQRODIMt4D
         v/X+DaJS4OfTTCR89wLGbpIdypZfmnMHMdwCbENJ8YrMU69oeamG58wuK0+n6z8GiMha
         0nV/mfY71eSiV5+LqnApKEGllmVHZACyA0f6kw4juHE1OKox5hUS01JXdQo7I/F1z8Ej
         zWkxGXYyD8OX1QhoTp+CCexhtNtPzvgd5e3PmW1Af+b778Klp5+MDW9mbHGVh1oQhXaB
         y34w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+EIuwxQt31o5B+KbEzTlzoMjGH0U8CnFlxdqbWmSS6g=;
        b=FUp/RiBJ/jUgIUkKjkfmhHTuWqwosvEsnV7kqe6sJR6q4WctlqWM8kMI1X/kTCOGHP
         Sk+kZyNGyVf2ml27UaiN0o9u1gsiqzKQAvXOHlFYcJOqtbJpe3plCAs3FtyI82772rQO
         WzI3XCrJ8QuFj+ePRiYDlfZfqVv1hB39M3KJOh3Y8OywQMhf6WC/OCzeunMyF3EcDRtv
         dE8ajtZJ1UyVuHbQdyEkX+2Q0VrOVO5d9wixYC3+D8lL00WCj+updBNxpyKEYbLLLzgv
         GETR9cLOZZ7tHDP/7XEgDDkFm8lDxret6ZpAZlOcKdwwNvxRMc9Wy/MtTZsyMhBfmlZr
         MFEg==
X-Gm-Message-State: APjAAAXXfVxXnIDJa2AiwYXF93UjaVBhlA8JLMq1rWDxoM70YSz5eTzb
        23H1vRRvqCSK4tBwUWuQJB8yrQO86BPZsPAlUyHZDQ==
X-Google-Smtp-Source: APXvYqxrFR5eBjphlNm3rcScGIdSFkSgiaa48AKGBlELi5jZAxlrdepjwQvBRFgOoEefvbqBtA1uWQ7xmK7J8DCQgDM=
X-Received: by 2002:a9d:470a:: with SMTP id a10mr18264911otf.166.1567999768034;
 Sun, 08 Sep 2019 20:29:28 -0700 (PDT)
MIME-Version: 1.0
References: <1567761088-125167-1-git-send-email-simon29rock@gmail.com> <1168eadb8203ae747c9d2c8b035aee97a697e1da.camel@poochiereds.net>
In-Reply-To: <1168eadb8203ae747c9d2c8b035aee97a697e1da.camel@poochiereds.net>
From:   simon gao <simon29rock@gmail.com>
Date:   Mon, 9 Sep 2019 11:29:17 +0800
Message-ID: <CAGR3woVf_1ChhNJgnH5+J604tBtAsVpBNamqjepWRdAwynRDBw@mail.gmail.com>
Subject: Re: [PATCH] add mount opt, optoauth, to force to send req to auth mds
 In larger clusters (hundreds of millions of files). We have to pin the
 directory on a fixed mds now. Some op of client use USE_ANY_MDS mode to
 access mds, which may result in requests being sent to noauth mds and then
 forwarded to authmds. the opt is used to reduce forward op.
To:     Jeff Layton <jlayton@poochiereds.net>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

yes. I will changed it.

Jeff Layton <jlayton@poochiereds.net> =E4=BA=8E2019=E5=B9=B49=E6=9C=886=E6=
=97=A5=E5=91=A8=E4=BA=94 =E4=B8=8B=E5=8D=887:13=E5=86=99=E9=81=93=EF=BC=9A
>
> It's ok to use line breaks so you don't end up with a subject line that
> long.
>
> On Fri, 2019-09-06 at 05:11 -0400, simon gao wrote:
> > ---
> >  fs/ceph/mds_client.c | 7 ++++++-
> >  fs/ceph/super.c      | 7 +++++++
> >  fs/ceph/super.h      | 1 +
> >  3 files changed, 14 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 920e9f0..3574e8f 100644
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
> > +     if (ma->flags & CEPH_MOUNT_OPT_OPTOAUTH && mode !=3D USE_AUTH_MDS=
){
>
> The mode check here doesn't seem to be necessary. Did you mainly add it
> so that the dout() message would fire when this is overridden?
>
> > +             dout("change mode %d =3D> USE_AUTH_MDS", mode);
> > +             mode =3D USE_AUTH_MDS;
> > +     }
> >       inode =3D NULL;
> >       if (req->r_inode) {
> >               if (ceph_snap(req->r_inode) !=3D CEPH_SNAPDIR) {
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index ab4868c..fbe8e2f 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -169,6 +169,7 @@ enum {
> >       Opt_noquotadf,
> >       Opt_copyfrom,
> >       Opt_nocopyfrom,
> > +     Opt_optoauth,
> >  };
> >
> >  static match_table_t fsopt_tokens =3D {
> > @@ -210,6 +211,7 @@ enum {
> >       {Opt_noquotadf, "noquotadf"},
> >       {Opt_copyfrom, "copyfrom"},
> >       {Opt_nocopyfrom, "nocopyfrom"},
> > +     {Opt_optoauth, "optoauth"},
>
> I'm not crazy about this option name as it's not very clear. Maybe
> something like "always_auth" would be better?
>
> >       {-1, NULL}
> >  };
> >
> > @@ -381,6 +383,9 @@ static int parse_fsopt_token(char *c, void *private=
)
> >       case Opt_noacl:
> >               fsopt->sb_flags &=3D ~SB_POSIXACL;
> >               break;
> > +     case Opt_optoauth:
> > +             fsopt->flags |=3D CEPH_MOUNT_OPT_OPTOAUTH;
> > +             break;
> >       default:
> >               BUG_ON(token);
> >       }
> > @@ -563,6 +568,8 @@ static int ceph_show_options(struct seq_file *m, st=
ruct dentry *root)
> >               seq_puts(m, ",nopoolperm");
> >       if (fsopt->flags & CEPH_MOUNT_OPT_NOQUOTADF)
> >               seq_puts(m, ",noquotadf");
> > +     if (fsopt->flags & CEPH_MOUNT_OPT_OPTOAUTH)
> > +             seq_puts(m, ",optoauth");
> >
> >  #ifdef CONFIG_CEPH_FS_POSIX_ACL
> >       if (fsopt->sb_flags & SB_POSIXACL)
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index 6b9f1ee..2710d5b 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -41,6 +41,7 @@
> >  #define CEPH_MOUNT_OPT_MOUNTWAIT       (1<<12) /* mount waits if no md=
s is up */
> >  #define CEPH_MOUNT_OPT_NOQUOTADF       (1<<13) /* no root dir quota in=
 statfs */
> >  #define CEPH_MOUNT_OPT_NOCOPYFROM      (1<<14) /* don't use RADOS 'cop=
y-from' op */
> > +#define CEPH_MOUNT_OPT_OPTOAUTH        (1<<15) /* send op to auth mds,=
 not to replicative mds */
> >
> >  #define CEPH_MOUNT_OPT_DEFAULT                       \
> >       (CEPH_MOUNT_OPT_DCACHE |                \
>
> --
> Jeff Layton <jlayton@poochiereds.net>
>
