Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1133B7386
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Jun 2021 15:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbhF2N5L (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Jun 2021 09:57:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24282 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233315AbhF2N5L (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 09:57:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624974883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K19wq5Mb6GHwkjSRwx+i6DKB1ShevGkkxTDxFFhf09s=;
        b=dhAKFPKvS/pQ9bb/J98bmFhfJNJjlKRWnHc3kS400ynAYtYbB/gB78EfOq/RzlvAxe39d7
        MLv+apesjuXEajfY+gvrlw1AiLdgRpuGGDFW4a5zx2W+yfPYOsUGC3nQd0334ZR3E+d8Ex
        uViNVXpi14ugyQ09yD71vzwpVk4Rwmc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-sBehqi8NNZ2quhxvyUtTWQ-1; Tue, 29 Jun 2021 09:54:42 -0400
X-MC-Unique: sBehqi8NNZ2quhxvyUtTWQ-1
Received: by mail-ej1-f69.google.com with SMTP id lb20-20020a1709077854b02904c5f93c0124so1618865ejc.14
        for <ceph-devel@vger.kernel.org>; Tue, 29 Jun 2021 06:54:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=K19wq5Mb6GHwkjSRwx+i6DKB1ShevGkkxTDxFFhf09s=;
        b=sMV0QGzJWKbYwERQu+Y+A8i/MvbAkJfs2L9xH852dAlxZ4BNGMEzbMsY0475F5n0MY
         s8UNkhz7dekZ1S448oHj4KXGD+MpeL7vSwvfPbIikI9UEawM3nnqTT8nOoYqvMdKfwbX
         oqQzdBv7gTofX+3PrS15vydDR8sEjKx1Cpxby1w9szSq9IxhCJsjlBhQo5UODNgIOPit
         UzwPivWeJK+Ycu7NFXH+9aWjvEvRpQ1nqvC+j3g1be2H+G1aIKwTwCC8S67x1Ita4Md1
         rgwlLLbEIh7Fs+z8gR75KlunpSAhf1T9AcaR2McDnZK665W5U/vAy8xqVF1KiaD7Lqtj
         xlKg==
X-Gm-Message-State: AOAM531S/W9a6Y1jheO353079x4lHYeZpyhyUM6aalfLrQJ+IRFFWGup
        zDOfQxCaWJKmOtOETzRzwDWoBEgl0+u3Bn8UxlEKU7YJrepuymZ+YT6oDlcULNAqZ3jwmtMnp5Z
        0grm5RALL/FYabZ17XyLi5LckOqtw1n4bO0A6fA==
X-Received: by 2002:a17:907:96a0:: with SMTP id hd32mr29301165ejc.198.1624974880651;
        Tue, 29 Jun 2021 06:54:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz82RqQ9KQsy4+KYfzkpoB6tDQVSBpremFocpg8y19fjuKwgLcI8i/rutTRyO38dTp0EDIkM70vGTks54kJkqY=
X-Received: by 2002:a17:907:96a0:: with SMTP id hd32mr29301153ejc.198.1624974880433;
 Tue, 29 Jun 2021 06:54:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210628075545.702106-1-vshankar@redhat.com> <20210628075545.702106-2-vshankar@redhat.com>
 <YNsEs9IwTEEqOTHj@suse.de>
In-Reply-To: <YNsEs9IwTEEqOTHj@suse.de>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Tue, 29 Jun 2021 19:24:04 +0530
Message-ID: <CACPzV1=KaZU5Y4NL-Sy1J-nfd+WddXydQc3o-kVmoe-pEiXiqA@mail.gmail.com>
Subject: Re: [PATCH 1/4] ceph: new device mount syntax
To:     Luis Henriques <lhenriques@suse.de>
Cc:     Jeff Layton <jlayton@redhat.com>, idryomov@gmail.com,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 29, 2021 at 5:02 PM Luis Henriques <lhenriques@suse.de> wrote:
>
> [ As I said, I didn't fully reviewed this patch.  Just sending out a few
>   comments. ]
>
> On Mon, Jun 28, 2021 at 01:25:42PM +0530, Venky Shankar wrote:
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
> >  fs/ceph/super.c | 117 +++++++++++++++++++++++++++++++++++++++++++-----
> >  fs/ceph/super.h |   3 ++
> >  2 files changed, 110 insertions(+), 10 deletions(-)
> >
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index 9b1b7f4cfdd4..950a28ad9c59 100644
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
> > @@ -226,10 +228,68 @@ static void canonicalize_path(char *path)
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
> > +     if (*dev_name_end !=3D '=3D')
> > +                return invalfc(fc, "separator '=3D' missing in source"=
);
>
> An annoying thing is that we'll always see this error message when fallin=
g
> back to the old_source method.
>
> (Also, is there a good reason for using '=3D' instead of ':'?  I probably
> missed this discussion somewhere else already...)
>
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
> > @@ -262,22 +322,48 @@ static int ceph_parse_source(struct fs_parameter =
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
> >
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
> > +     fsopt->mon_addr =3D kstrdup(param->string, GFP_KERNEL);
> > +     if (!fsopt->mon_addr)
> > +             return -ENOMEM;
> > +
> > +     strreplace(param->string, '/', ',');
> > +     r =3D ceph_parse_mon_ips(param->string, strlen(param->string),
> > +                            pctx->copts, fc->log.log);
> > +     param->string =3D NULL;
>
> I think this will result in a memory leak.  Why don't we simply set
> fsopt->mon_addr to param->string instead of kstrdup'ing it?

Sure. As discussed over irc, will do away with the alloc.

>
> Cheers,
> --
> Lu=C3=ADs
>
> > +     return r;
> >  }
> >
> >  static int ceph_parse_mount_param(struct fs_context *fc,
> > @@ -322,6 +408,8 @@ static int ceph_parse_mount_param(struct fs_context=
 *fc,
> >               if (fc->source)
> >                       return invalfc(fc, "Multiple sources specified");
> >               return ceph_parse_source(param, fc);
> > +     case Opt_mon_addr:
> > +             return ceph_parse_mon_addr(param, fc);
> >       case Opt_wsize:
> >               if (result.uint_32 < PAGE_SIZE ||
> >                   result.uint_32 > CEPH_MAX_WRITE_SIZE)
> > @@ -473,6 +561,7 @@ static void destroy_mount_options(struct ceph_mount=
_options *args)
> >       kfree(args->mds_namespace);
> >       kfree(args->server_path);
> >       kfree(args->fscache_uniq);
> > +     kfree(args->mon_addr);
> >       kfree(args);
> >  }
> >
> > @@ -516,6 +605,10 @@ static int compare_mount_options(struct ceph_mount=
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
> > @@ -571,9 +664,13 @@ static int ceph_show_options(struct seq_file *m, s=
truct dentry *root)
> >       if ((fsopt->flags & CEPH_MOUNT_OPT_NOCOPYFROM) =3D=3D 0)
> >               seq_puts(m, ",copyfrom");
> >
> > -     if (fsopt->mds_namespace)
> > +     /* dump mds_namespace when old device syntax is in use */
> > +     if (fsopt->mds_namespace && !fsopt->new_dev_syntax)
> >               seq_show_option(m, "mds_namespace", fsopt->mds_namespace)=
;
> >
> > +     if (fsopt->mon_addr)
> > +             seq_printf(m, ",mon_addr=3D%s", fsopt->mon_addr);
> > +
> >       if (fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)
> >               seq_show_option(m, "recover_session", "clean");
> >
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index 839e6b0239ee..557348ff3203 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -88,6 +88,8 @@ struct ceph_mount_options {
> >       unsigned int max_readdir;       /* max readdir result (entries) *=
/
> >       unsigned int max_readdir_bytes; /* max readdir result (bytes) */
> >
> > +     bool new_dev_syntax;
> > +
> >       /*
> >        * everything above this point can be memcmp'd; everything below
> >        * is handled in compare_mount_options()
> > @@ -97,6 +99,7 @@ struct ceph_mount_options {
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

