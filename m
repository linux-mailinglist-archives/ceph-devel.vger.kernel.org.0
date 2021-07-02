Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CAAB3B9F77
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Jul 2021 13:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhGBLI5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 2 Jul 2021 07:08:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34215 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231126AbhGBLI5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 2 Jul 2021 07:08:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625223984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YVA3MRwPvMmK2lPvj5YQfD/5JFpKKqPfyCEbz6+xlfM=;
        b=OdOZP3mYVLnZGqxvXkLUdtoDy6LJ/dmkb8qtMNTSqEtiaSX+XxvCs8B4A+zQMOte4W3peg
        Rb/3nZM647w5X7YSLsKO5YAE4c3WGSpUlDqvAHPritpEOW9Tt/0OqFdXpE95Ivf/lXchM2
        pHGz1n2qoB5WR58vTvbQiggi/YX4n2s=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-7OPyCMRyPrGuxQ5luKutWA-1; Fri, 02 Jul 2021 07:06:23 -0400
X-MC-Unique: 7OPyCMRyPrGuxQ5luKutWA-1
Received: by mail-ej1-f71.google.com with SMTP id hy7-20020a1709068a67b02904cdf8737a75so2584641ejc.9
        for <ceph-devel@vger.kernel.org>; Fri, 02 Jul 2021 04:06:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YVA3MRwPvMmK2lPvj5YQfD/5JFpKKqPfyCEbz6+xlfM=;
        b=dajX+6m+ZVOY0GDjC/qQ+Zf72uN5Za7aowG5aEr513U4oua/eAVdT3Xu0D4IVOHMZq
         e+jFg7B7KdWCNHdmu+gPMX6sixJAyY3rZkIma76tC9nR1DZUsS6VK3TGOh5LTOnBj/Hp
         aawdyc2mogLrxxsMxh+HMRX0dLj9Ofef03z54DkafJiGyoaKaCyocaq+EY2IkPArrcCK
         34RFduwDNqalrEE6OwjvmqfTjBlxftPWQUY/aMY4XwySD8J+E/idT6aBZSilvcqR163F
         kzkTDPuuDUOCR9AsyzyU/u5klFaiHXZVMqS92qEd79Re9o6Z8/sjN+rhhcIHJPLriPT6
         kbzA==
X-Gm-Message-State: AOAM532kFSUbN1+oLP4nXz+zl8mS2LcSZEgY+52KAwdui1CSLEZBXo8S
        vI8TqJJ2y/QVP5O5/sposicIlJ0CRd7FLg6QJu5PT8uRL8lzH8BTOKAulQqA8iF8jDlvkgO1YAN
        bhC97uCYBgpkx5OCjMfHhdyEJVx67eEWu6viOFA==
X-Received: by 2002:a17:906:3489:: with SMTP id g9mr4678216ejb.282.1625223982110;
        Fri, 02 Jul 2021 04:06:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSFDuZggSep14BPj1eua8qxhIDqIkN+k/BEr97BrjmsPPQkLHZ1OcHW+h3GFyp9/U10zKmuGmq9NqmKrfYu3M=
X-Received: by 2002:a17:906:3489:: with SMTP id g9mr4678176ejb.282.1625223981676;
 Fri, 02 Jul 2021 04:06:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210702064821.148063-1-vshankar@redhat.com> <20210702064821.148063-2-vshankar@redhat.com>
 <YN7smzFk20Oyhixi@suse.de>
In-Reply-To: <YN7smzFk20Oyhixi@suse.de>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Fri, 2 Jul 2021 16:35:45 +0530
Message-ID: <CACPzV1k6RYqp+tE0g2q4LLfwvXM6MYsC8w7RYaF81LETcjbWWw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] ceph: new device mount syntax
To:     Luis Henriques <lhenriques@suse.de>
Cc:     Jeff Layton <jlayton@redhat.com>, idryomov@gmail.com,
        Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jul 2, 2021 at 4:08 PM Luis Henriques <lhenriques@suse.de> wrote:
>
> On Fri, Jul 02, 2021 at 12:18:18PM +0530, Venky Shankar wrote:
> > Old mount device syntax (source) has the following problems:
> >
> > - mounts to the same cluster but with different fsnames
> >   and/or creds have identical device string which can
> >   confuse xfstests.
> >
> > - Userspace mount helper tool resolves monitor addresses
> >   and fill in mon addrs automatically, but that means the
> >   device shown in /proc/mounts is different than what was
> >   used for mounting.
> >
> > New device syntax is as follows:
> >
> >   cephuser@fsid.mycephfs2=3D/path
> >
> > Note, there is no "monitor address" in the device string.
> > That gets passed in as mount option. This keeps the device
> > string same when monitor addresses change (on remounts).
> >
> > Also note that the userspace mount helper tool is backward
> > compatible. I.e., the mount helper will fallback to using
> > old syntax after trying to mount with the new syntax.
> >
> > Signed-off-by: Venky Shankar <vshankar@redhat.com>
> > ---
> >  fs/ceph/super.c | 122 ++++++++++++++++++++++++++++++++++++++++++++----
> >  fs/ceph/super.h |   3 ++
> >  2 files changed, 115 insertions(+), 10 deletions(-)
> >
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index 9b1b7f4cfdd4..0b324e43c9f4 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -145,6 +145,7 @@ enum {
> >       Opt_mds_namespace,
> >       Opt_recover_session,
> >       Opt_source,
> > +     Opt_mon_addr,
> >       /* string args above */
> >       Opt_dirstat,
> >       Opt_rbytes,
> > @@ -196,6 +197,7 @@ static const struct fs_parameter_spec ceph_mount_pa=
rameters[] =3D {
> >       fsparam_u32     ("rsize",                       Opt_rsize),
> >       fsparam_string  ("snapdirname",                 Opt_snapdirname),
> >       fsparam_string  ("source",                      Opt_source),
> > +     fsparam_string  ("mon_addr",                    Opt_mon_addr),
> >       fsparam_u32     ("wsize",                       Opt_wsize),
> >       fsparam_flag_no ("wsync",                       Opt_wsync),
> >       {}
> > @@ -226,10 +228,70 @@ static void canonicalize_path(char *path)
> >       path[j] =3D '\0';
> >  }
> >
> > +static int ceph_parse_old_source(const char *dev_name, const char *dev=
_name_end,
> > +                              struct fs_context *fc)
> > +{
> > +     int r;
> > +     struct ceph_parse_opts_ctx *pctx =3D fc->fs_private;
> > +     struct ceph_mount_options *fsopt =3D pctx->opts;
> > +
> > +     if (*dev_name_end !=3D ':')
> > +             return invalfc(fc, "separator ':' missing in source");
> > +
> > +     r =3D ceph_parse_mon_ips(dev_name, dev_name_end - dev_name,
> > +                            pctx->copts, fc->log.log);
> > +     if (r)
> > +             return r;
> > +
> > +     fsopt->new_dev_syntax =3D false;
> > +     return 0;
> > +}
> > +
> > +static int ceph_parse_new_source(const char *dev_name, const char *dev=
_name_end,
> > +                              struct fs_context *fc)
> > +{
> > +     struct ceph_parse_opts_ctx *pctx =3D fc->fs_private;
> > +     struct ceph_mount_options *fsopt =3D pctx->opts;
> > +     char *fsid_start, *fs_name_start;
> > +
> > +     if (*dev_name_end !=3D '=3D') {
> > +             dout("separator '=3D' missing in source");
> > +             return -EINVAL;
> > +     }
> > +
> > +     fsid_start =3D strchr(dev_name, '@');
> > +     if (!fsid_start)
> > +             return invalfc(fc, "missing cluster fsid");
> > +     ++fsid_start; /* start of cluster fsid */
> > +
> > +     fs_name_start =3D strchr(fsid_start, '.');
> > +     if (!fs_name_start)
> > +             return invalfc(fc, "missing file system name");
> > +
> > +     ++fs_name_start; /* start of file system name */
> > +     fsopt->mds_namespace =3D kstrndup(fs_name_start,
> > +                                     dev_name_end - fs_name_start, GFP=
_KERNEL);
> > +     if (!fsopt->mds_namespace)
> > +             return -ENOMEM;
> > +     dout("file system (mds namespace) '%s'\n", fsopt->mds_namespace);
> > +
> > +     fsopt->new_dev_syntax =3D true;
> > +     return 0;
> > +}
> > +
> >  /*
> > - * Parse the source parameter.  Distinguish the server list from the p=
ath.
> > + * Parse the source parameter for new device format. Distinguish the d=
evice
> > + * spec from the path. Try parsing new device format and fallback to o=
ld
> > + * format if needed.
> >   *
> > - * The source will look like:
> > + * New device syntax will looks like:
> > + *     <device_spec>=3D/<path>
> > + * where
> > + *     <device_spec> is name@fsid.fsname
> > + *     <path> is optional, but if present must begin with '/'
> > + * (monitor addresses are passed via mount option)
> > + *
> > + * Old device syntax is:
> >   *     <server_spec>[,<server_spec>...]:[<path>]
> >   * where
> >   *     <server_spec> is <ip>[:<port>]
> > @@ -262,22 +324,48 @@ static int ceph_parse_source(struct fs_parameter =
*param, struct fs_context *fc)
> >               dev_name_end =3D dev_name + strlen(dev_name);
> >       }
> >
> > -     dev_name_end--;         /* back up to ':' separator */
> > -     if (dev_name_end < dev_name || *dev_name_end !=3D ':')
> > -             return invalfc(fc, "No path or : separator in source");
> > +     dev_name_end--;         /* back up to separator */
> > +     if (dev_name_end < dev_name)
> > +             return invalfc(fc, "path missing in source");
> >
> >       dout("device name '%.*s'\n", (int)(dev_name_end - dev_name), dev_=
name);
> >       if (fsopt->server_path)
> >               dout("server path '%s'\n", fsopt->server_path);
> >
> > -     ret =3D ceph_parse_mon_ips(param->string, dev_name_end - dev_name=
,
> > -                              pctx->copts, fc->log.log);
> > +     dout("trying new device syntax");
> > +     ret =3D ceph_parse_new_source(dev_name, dev_name_end, fc);
> > +     if (ret =3D=3D 0)
> > +             goto done;
> > +
> > +     dout("trying old device syntax");
> > +     ret =3D ceph_parse_old_source(dev_name, dev_name_end, fc);
> >       if (ret)
> > -             return ret;
> > +             goto out;
>
> Do we really need this goto?  My (personal) preference would be to drop
> this one and simply return.   And maybe it's even possible to drop the
> previous 'goto done' too.

Sure. Just a preference I had.

>
> > + done:
> >       fc->source =3D param->string;
> >       param->string =3D NULL;
> > -     return 0;
> > + out:
> > +     return ret;
> > +}
> > +
> > +static int ceph_parse_mon_addr(struct fs_parameter *param,
> > +                            struct fs_context *fc)
> > +{
> > +     int r;
> > +     struct ceph_parse_opts_ctx *pctx =3D fc->fs_private;
> > +     struct ceph_mount_options *fsopt =3D pctx->opts;
> > +
> > +     kfree(fsopt->mon_addr);
> > +     fsopt->mon_addr =3D param->string;
> > +     param->string =3D NULL;
> > +
> > +     strreplace(fsopt->mon_addr, '/', ',');
> > +     r =3D ceph_parse_mon_ips(fsopt->mon_addr, strlen(fsopt->mon_addr)=
,
> > +                            pctx->copts, fc->log.log);
> > +        // since its used in ceph_show_options()
>
> (nit: use c-style comments...? yeah, again personal preference :-)
>
> > +     strreplace(fsopt->mon_addr, ',', '/');
>
> This is ugly.  Have you considered modifying ceph_parse_mon_ips() (and
> ceph_parse_ips()) to receive a delimiter as a parameter?''

I did. However, for most cases (all possibly), "," is the addr
delimiter. So, I didn't take the approach to make these helpers really
generic for parsing addrs.

>
> > +     return r;
> >  }
> >
> >  static int ceph_parse_mount_param(struct fs_context *fc,
> > @@ -322,6 +410,8 @@ static int ceph_parse_mount_param(struct fs_context=
 *fc,
> >               if (fc->source)
> >                       return invalfc(fc, "Multiple sources specified");
> >               return ceph_parse_source(param, fc);
> > +     case Opt_mon_addr:
> > +             return ceph_parse_mon_addr(param, fc);
> >       case Opt_wsize:
> >               if (result.uint_32 < PAGE_SIZE ||
> >                   result.uint_32 > CEPH_MAX_WRITE_SIZE)
> > @@ -473,6 +563,7 @@ static void destroy_mount_options(struct ceph_mount=
_options *args)
> >       kfree(args->mds_namespace);
> >       kfree(args->server_path);
> >       kfree(args->fscache_uniq);
> > +     kfree(args->mon_addr);
> >       kfree(args);
> >  }
> >
> > @@ -516,6 +607,10 @@ static int compare_mount_options(struct ceph_mount=
_options *new_fsopt,
> >       if (ret)
> >               return ret;
> >
> > +     ret =3D strcmp_null(fsopt1->mon_addr, fsopt2->mon_addr);
> > +     if (ret)
> > +             return ret;
> > +
> >       return ceph_compare_options(new_opt, fsc->client);
> >  }
> >
> > @@ -571,9 +666,13 @@ static int ceph_show_options(struct seq_file *m, s=
truct dentry *root)
> >       if ((fsopt->flags & CEPH_MOUNT_OPT_NOCOPYFROM) =3D=3D 0)
> >               seq_puts(m, ",copyfrom");
> >
> > -     if (fsopt->mds_namespace)
> > +     /* dump mds_namespace when old device syntax is in use */
> > +     if (fsopt->mds_namespace && !fsopt->new_dev_syntax)
> >               seq_show_option(m, "mds_namespace", fsopt->mds_namespace)=
;
>
> I haven't really tested it, but... what happens if we set mds_namespace
> *and* we're using the new syntax?  Or, in another words, what should
> happen?

Depends on the order of token parsing in ceph_parse_mount_param()
which mds_namespace gets used.

(however, that means ceph_parse_new_source() should additionally
kfree(fsopt->mds_namespace)).

>
> Cheers,
> --
> Lu=C3=ADs
>
> >
> > +     if (fsopt->mon_addr)
> > +             seq_printf(m, ",mon_addr=3D%s", fsopt->mon_addr);
> > +
> >       if (fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)
> >               seq_show_option(m, "recover_session", "clean");
> >
> > @@ -1048,6 +1147,7 @@ static int ceph_setup_bdi(struct super_block *sb,=
 struct ceph_fs_client *fsc)
> >  static int ceph_get_tree(struct fs_context *fc)
> >  {
> >       struct ceph_parse_opts_ctx *pctx =3D fc->fs_private;
> > +     struct ceph_mount_options *fsopt =3D pctx->opts;
> >       struct super_block *sb;
> >       struct ceph_fs_client *fsc;
> >       struct dentry *res;
> > @@ -1059,6 +1159,8 @@ static int ceph_get_tree(struct fs_context *fc)
> >
> >       if (!fc->source)
> >               return invalfc(fc, "No source");
> > +     if (fsopt->new_dev_syntax && !fsopt->mon_addr)
> > +             return invalfc(fc, "No monitor address");
> >
> >       /* create client (which we may/may not use) */
> >       fsc =3D create_fs_client(pctx->opts, pctx->copts);
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index c48bb30c8d70..8f71184b7c85 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -87,6 +87,8 @@ struct ceph_mount_options {
> >       unsigned int max_readdir;       /* max readdir result (entries) *=
/
> >       unsigned int max_readdir_bytes; /* max readdir result (bytes) */
> >
> > +     bool new_dev_syntax;
> > +
> >       /*
> >        * everything above this point can be memcmp'd; everything below
> >        * is handled in compare_mount_options()
> > @@ -96,6 +98,7 @@ struct ceph_mount_options {
> >       char *mds_namespace;  /* default NULL */
> >       char *server_path;    /* default NULL (means "/") */
> >       char *fscache_uniq;   /* default NULL */
> > +     char *mon_addr;
> >  };
> >
> >  struct ceph_fs_client {
> > --
> > 2.27.0
> >
>


--=20
Cheers,
Venky

