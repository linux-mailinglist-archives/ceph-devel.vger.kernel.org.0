Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4BD039B832
	for <lists+ceph-devel@lfdr.de>; Fri,  4 Jun 2021 13:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhFDLov (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 4 Jun 2021 07:44:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38969 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229958AbhFDLov (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 4 Jun 2021 07:44:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622806984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KxQXBVUy1/swmHQYXHnG1g6XoF/Nkoth22vtk5rYRgo=;
        b=gPbojuUBHcJAjWhZnH8QQTQUOAA83GhzGYE3r6Np28PVMeLu+fklhgHXWyqGVQMI+RwzVa
        Har0KWHCZtqwVYFc8xM8P/c44/i4HKNysUYQxhbY4IbwCuRirRde+mB9NmwQ8OSXvOxsVc
        vRxFP1CKZJcEuDKxyPPzddRXWPxsjQg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-krBNmKKcP9GW_RxMRpUkXg-1; Fri, 04 Jun 2021 07:43:03 -0400
X-MC-Unique: krBNmKKcP9GW_RxMRpUkXg-1
Received: by mail-ed1-f71.google.com with SMTP id v18-20020a0564023492b029038d5ad7c8a8so4857781edc.11
        for <ceph-devel@vger.kernel.org>; Fri, 04 Jun 2021 04:43:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KxQXBVUy1/swmHQYXHnG1g6XoF/Nkoth22vtk5rYRgo=;
        b=SZoZcyXGbTC8bNqN8BAGYX/9h8fHUDM6fSAvhoedfx9czDNg7xw89Wc8paCW2WDtsO
         qxaUrlRVOEwoozVV+GkfDAHjVSGeDufJNN1+ocPU6nufxBoiA6WLrztdf96TDZnvATce
         oZMNLiDYcfIG+zFM6bdfcizea/5V86iv+qQMS/4HvOCEzyTxPiqiynrC5hcekBm7vwDR
         u1V2SQUuccNwvaEgIBww+Jig35JyHvqf6E+kQDORwGy5sTodZVnktHd+/5WMe7l9VALL
         GIU9tWyeInev6r6+jVJBLgSWm72DfTqdsqrzl3eSqkt2icYQpJpQqpZw0nD7tkvfyqAO
         wgqQ==
X-Gm-Message-State: AOAM531kQ/yCKSOzIsuvb/bCvyNdT4qyDnDE6tscQXewIjaMkAotDTJD
        tBIw9UGn1sH6wykE3He8ilF1k5gMep6rPFzY69vSm8A89tM9jU27phN2TZH5CbR2UOn9/Ce0ooI
        Ka4D2ImnoCI+rB7jSH0yUJ/yPRRc6ao5JD8iMlQ==
X-Received: by 2002:a17:906:4ac4:: with SMTP id u4mr2730989ejt.229.1622806981952;
        Fri, 04 Jun 2021 04:43:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2jGlv87LIbj9kcbbq9wQo5/OAibH5KRKU+lURHBLrYPisI9lzHxdCPTPDaJjdo6tpl8gwFgf41lNFkO125Ak=
X-Received: by 2002:a17:906:4ac4:: with SMTP id u4mr2730978ejt.229.1622806981658;
 Fri, 04 Jun 2021 04:43:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210604050512.552649-1-vshankar@redhat.com> <20210604050512.552649-2-vshankar@redhat.com>
 <c0d58ca68157e2f3ec527d63a8986ec6fc3be60f.camel@kernel.org>
In-Reply-To: <c0d58ca68157e2f3ec527d63a8986ec6fc3be60f.camel@kernel.org>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Fri, 4 Jun 2021 17:12:25 +0530
Message-ID: <CACPzV1n7-ad4_ZkoGaCrTj5StEo=FtuMidaWc2ex_6cxRNi1fA@mail.gmail.com>
Subject: Re: [PATCH 1/3] ceph: new device mount syntax
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jun 4, 2021 at 4:45 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Fri, 2021-06-04 at 10:35 +0530, Venky Shankar wrote:
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
> >   cephuser@mycephfs2=/path
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
> >  fs/ceph/super.c | 69 +++++++++++++++++++++++++++++++++----------------
> >  fs/ceph/super.h |  1 +
> >  2 files changed, 48 insertions(+), 22 deletions(-)
> >
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index 9b1b7f4cfdd4..e273eabb0397 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -142,9 +142,9 @@ enum {
> >       Opt_congestion_kb,
> >       /* int args above */
> >       Opt_snapdirname,
> > -     Opt_mds_namespace,
>
> I don't think we can just remove the old mds_namespace option. What if
> we have an old mount helper with the new kernel? It'll pass that in as
> an option and it wouldn't be recognized.

Ah, ok. I kind of assumed that old user space + new kernel need not be
taken care of.

That means the new kernel should preserve old mount syntax for old
user space helper.

>
> >       Opt_recover_session,
> >       Opt_source,
> > +     Opt_mon_addr,
> >       /* string args above */
> >       Opt_dirstat,
> >       Opt_rbytes,
> > @@ -184,7 +184,6 @@ static const struct fs_parameter_spec ceph_mount_parameters[] = {
> >       fsparam_flag_no ("fsc",                         Opt_fscache), // fsc|nofsc
> >       fsparam_string  ("fsc",                         Opt_fscache), // fsc=...
> >       fsparam_flag_no ("ino32",                       Opt_ino32),
> > -     fsparam_string  ("mds_namespace",               Opt_mds_namespace),
> >       fsparam_flag_no ("poolperm",                    Opt_poolperm),
> >       fsparam_flag_no ("quotadf",                     Opt_quotadf),
> >       fsparam_u32     ("rasize",                      Opt_rasize),
> > @@ -196,6 +195,7 @@ static const struct fs_parameter_spec ceph_mount_parameters[] = {
> >       fsparam_u32     ("rsize",                       Opt_rsize),
> >       fsparam_string  ("snapdirname",                 Opt_snapdirname),
> >       fsparam_string  ("source",                      Opt_source),
> > +     fsparam_string  ("mon_addr",                    Opt_mon_addr),
> >       fsparam_u32     ("wsize",                       Opt_wsize),
> >       fsparam_flag_no ("wsync",                       Opt_wsync),
> >       {}
> > @@ -227,12 +227,12 @@ static void canonicalize_path(char *path)
> >  }
> >
> >  /*
> > - * Parse the source parameter.  Distinguish the server list from the path.
> > + * Parse the source parameter.  Distinguish the device spec from the path.
> >   *
> >   * The source will look like:
> > - *     <server_spec>[,<server_spec>...]:[<path>]
> > + *     <device_spec>=/<path>
> >   * where
> > - *     <server_spec> is <ip>[:<port>]
> > + *     <device_spec> is name@fsname
> >   *     <path> is optional, but if present must begin with '/'
> >   */
> >  static int ceph_parse_source(struct fs_parameter *param, struct fs_context *fc)
> > @@ -240,12 +240,17 @@ static int ceph_parse_source(struct fs_parameter *param, struct fs_context *fc)
> >       struct ceph_parse_opts_ctx *pctx = fc->fs_private;
> >       struct ceph_mount_options *fsopt = pctx->opts;
> >       char *dev_name = param->string, *dev_name_end;
> > -     int ret;
> > +     char *fs_name_start;
> >
> >       dout("%s '%s'\n", __func__, dev_name);
> >       if (!dev_name || !*dev_name)
> >               return invalfc(fc, "Empty source");
> >
> > +     fs_name_start = strchr(dev_name, '@');
> > +     if (!fs_name_start)
> > +             return invalfc(fc, "Missing file system name");
> > +     ++fs_name_start; /* start of file system name */
> > +
> >       dev_name_end = strchr(dev_name, '/');
> >       if (dev_name_end) {
> >               /*
> > @@ -262,24 +267,42 @@ static int ceph_parse_source(struct fs_parameter *param, struct fs_context *fc)
> >               dev_name_end = dev_name + strlen(dev_name);
> >       }
> >
> > -     dev_name_end--;         /* back up to ':' separator */
> > -     if (dev_name_end < dev_name || *dev_name_end != ':')
> > -             return invalfc(fc, "No path or : separator in source");
> > +     dev_name_end--;         /* back up to '=' separator */
> > +     if (dev_name_end < dev_name || *dev_name_end != '=')
> > +             return invalfc(fc, "No path or = separator in source");
> >
> >       dout("device name '%.*s'\n", (int)(dev_name_end - dev_name), dev_name);
> > -     if (fsopt->server_path)
> > -             dout("server path '%s'\n", fsopt->server_path);
> >
> > -     ret = ceph_parse_mon_ips(param->string, dev_name_end - dev_name,
> > -                              pctx->copts, fc->log.log);
> > -     if (ret)
> > -             return ret;
> > +     fsopt->mds_namespace = kstrndup(fs_name_start,
> > +                                     dev_name_end - fs_name_start, GFP_KERNEL);
> > +     dout("file system (mds namespace) '%s'\n", fsopt->mds_namespace);
> >
> > +     if (fsopt->server_path)
> > +             dout("server path '%s'\n", fsopt->server_path);
> >       fc->source = param->string;
> >       param->string = NULL;
> >       return 0;
> >  }
> >
> > +static int ceph_parse_mon_addr(struct fs_parameter *param,
> > +                            struct fs_context *fc)
> > +{
> > +     int r;
> > +     struct ceph_parse_opts_ctx *pctx = fc->fs_private;
> > +     struct ceph_mount_options *fsopt = pctx->opts;
> > +
> > +     kfree(fsopt->mon_addr);
> > +     fsopt->mon_addr = kstrdup(param->string, GFP_KERNEL);
> > +     if (!fsopt->mon_addr)
> > +             return -ENOMEM;
> > +
> > +     strreplace(param->string, '/', ',');
> > +     r = ceph_parse_mon_ips(param->string, strlen(param->string),
> > +                            pctx->copts, fc->log.log);
> > +     param->string = NULL;
> > +     return r;
> > +}
> > +
> >  static int ceph_parse_mount_param(struct fs_context *fc,
> >                                 struct fs_parameter *param)
> >  {
> > @@ -304,11 +327,6 @@ static int ceph_parse_mount_param(struct fs_context *fc,
> >               fsopt->snapdir_name = param->string;
> >               param->string = NULL;
> >               break;
> > -     case Opt_mds_namespace:
> > -             kfree(fsopt->mds_namespace);
> > -             fsopt->mds_namespace = param->string;
> > -             param->string = NULL;
> > -             break;
> >       case Opt_recover_session:
> >               mode = result.uint_32;
> >               if (mode == ceph_recover_session_no)
> > @@ -322,6 +340,8 @@ static int ceph_parse_mount_param(struct fs_context *fc,
> >               if (fc->source)
> >                       return invalfc(fc, "Multiple sources specified");
> >               return ceph_parse_source(param, fc);
> > +     case Opt_mon_addr:
> > +             return ceph_parse_mon_addr(param, fc);
> >       case Opt_wsize:
> >               if (result.uint_32 < PAGE_SIZE ||
> >                   result.uint_32 > CEPH_MAX_WRITE_SIZE)
> > @@ -473,6 +493,7 @@ static void destroy_mount_options(struct ceph_mount_options *args)
> >       kfree(args->mds_namespace);
> >       kfree(args->server_path);
> >       kfree(args->fscache_uniq);
> > +     kfree(args->mon_addr);
> >       kfree(args);
> >  }
> >
> > @@ -516,6 +537,10 @@ static int compare_mount_options(struct ceph_mount_options *new_fsopt,
> >       if (ret)
> >               return ret;
> >
> > +     ret = strcmp_null(fsopt1->mon_addr, fsopt2->mon_addr);
> > +     if (ret)
> > +             return ret;
> > +
> >       return ceph_compare_options(new_opt, fsc->client);
> >  }
> >
> > @@ -571,8 +596,8 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
> >       if ((fsopt->flags & CEPH_MOUNT_OPT_NOCOPYFROM) == 0)
> >               seq_puts(m, ",copyfrom");
> >
> > -     if (fsopt->mds_namespace)
> > -             seq_show_option(m, "mds_namespace", fsopt->mds_namespace);
> > +     if (fsopt->mon_addr)
> > +             seq_printf(m, ",mon_addr=%s", fsopt->mon_addr);
> >
> >       if (fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)
> >               seq_show_option(m, "recover_session", "clean");
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index db80d89556b1..ead73dfb8804 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -97,6 +97,7 @@ struct ceph_mount_options {
> >       char *mds_namespace;  /* default NULL */
> >       char *server_path;    /* default NULL (means "/") */
> >       char *fscache_uniq;   /* default NULL */
> > +     char *mon_addr;
> >  };
> >
> >  struct ceph_fs_client {
>
> --
> Jeff Layton <jlayton@kernel.org>
>


-- 
Cheers,
Venky

