Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2023B74EF
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Jun 2021 17:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234785AbhF2PMg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Jun 2021 11:12:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21580 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234741AbhF2PMd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 11:12:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624979405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cFf1q+gI+p5U7hpsK5WrVGyadzH9kxbubcjIWWlISZU=;
        b=SgaRoWXYrViFrXpF58tiJ2ZMMuJQ3ZABbzV+NtIqtDR1YXXr4YtYK2A2Ib7YEeR6jF2XcW
        bZj4nYE6Rn1zREwjZi91ls3BTSlLTT755PCYcmxtkEq0XrTMXbZ+qkNT247px+lM/QQDlG
        lwdYVJrWPl7k30jUPyvqZNN5Xf86Cm0=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-Yn8ITkv6NNqPkrnhoo77JA-1; Tue, 29 Jun 2021 11:10:04 -0400
X-MC-Unique: Yn8ITkv6NNqPkrnhoo77JA-1
Received: by mail-qk1-f197.google.com with SMTP id a2-20020a05620a0662b02903ad3598ec02so14421154qkh.17
        for <ceph-devel@vger.kernel.org>; Tue, 29 Jun 2021 08:10:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=cFf1q+gI+p5U7hpsK5WrVGyadzH9kxbubcjIWWlISZU=;
        b=t6uyBg2k4jzLOhE744I7zhGI2rPeDKhOw1GIMVPuObYRO2Z/zuc3GgPvqDWjjpXCM0
         U1cUEhjajRFDbDnaiqi5K4Mw2By+BS/tWnkoR7c8Zhobqk50M4UvegIMxxnEdPEjlAge
         7GF1toXN2EQDGYBHpcJhqYU2ICCvITqGqRXY0pksLgMFdqo3OCugwZwUO4Ca0JqROn/5
         YfIPgcF8J7oBgA4tBpA8sw8qtQSN6pDNXaTgxx9J7gA5rJLYa5I3VfzWDshYhwDWnv+Q
         cRibCF4dmxJN+OUU+VJBMnonoCOqhF/ZuvSuGd1c/g+wGCmAuUHM2IxTo5GBjzv2RX/K
         iRGA==
X-Gm-Message-State: AOAM530dO9Nn/+S2tHcQpGOklm8QY1ibaLcRXXcWc+Y7z1fjgNNHPhvT
        Mnlnce2Fzyy4jKDwK0fbNwBmT48QemHxUDj1SvldjUREpJbkDQqH7uwcrv4dj0nINO+ziKLnJ94
        bSP/fk/ejdxy0qTw8A8FVeA==
X-Received: by 2002:ac8:149a:: with SMTP id l26mr26768081qtj.297.1624979403746;
        Tue, 29 Jun 2021 08:10:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzEMJNuzkaxuIxUcWwCvaWeWhw59QH9Gg0MN5dIeEtZbpKFiH5YVwqxwUy4294SLivHpvf2dg==
X-Received: by 2002:ac8:149a:: with SMTP id l26mr26768063qtj.297.1624979403513;
        Tue, 29 Jun 2021 08:10:03 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id z3sm12360313qkj.40.2021.06.29.08.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 08:10:03 -0700 (PDT)
Message-ID: <e3b6778ed89617efe869a530970f3dfe9d8d9d10.camel@redhat.com>
Subject: Re: [PATCH 1/4] ceph: new device mount syntax
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>,
        Luis Henriques <lhenriques@suse.de>
Cc:     idryomov@gmail.com, ceph-devel <ceph-devel@vger.kernel.org>
Date:   Tue, 29 Jun 2021 11:10:02 -0400
In-Reply-To: <CACPzV1=KaZU5Y4NL-Sy1J-nfd+WddXydQc3o-kVmoe-pEiXiqA@mail.gmail.com>
References: <20210628075545.702106-1-vshankar@redhat.com>
         <20210628075545.702106-2-vshankar@redhat.com> <YNsEs9IwTEEqOTHj@suse.de>
         <CACPzV1=KaZU5Y4NL-Sy1J-nfd+WddXydQc3o-kVmoe-pEiXiqA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-06-29 at 19:24 +0530, Venky Shankar wrote:
> On Tue, Jun 29, 2021 at 5:02 PM Luis Henriques <lhenriques@suse.de> wrote:
> > 
> > [ As I said, I didn't fully reviewed this patch.  Just sending out a few
> >   comments. ]
> > 
> > On Mon, Jun 28, 2021 at 01:25:42PM +0530, Venky Shankar wrote:
> > > Old mount device syntax (source) has the following problems:
> > > 
> > > - mounts to the same cluster but with different fsnames
> > >   and/or creds have identical device string which can
> > >   confuse xfstests.
> > > 
> > > - Userspace mount helper tool resolves monitor addresses
> > >   and fill in mon addrs automatically, but that means the
> > >   device shown in /proc/mounts is different than what was
> > >   used for mounting.
> > > 
> > > New device syntax is as follows:
> > > 
> > >   cephuser@fsid.mycephfs2=/path
> > > 
> > > Note, there is no "monitor address" in the device string.
> > > That gets passed in as mount option. This keeps the device
> > > string same when monitor addresses change (on remounts).
> > > 
> > > Also note that the userspace mount helper tool is backward
> > > compatible. I.e., the mount helper will fallback to using
> > > old syntax after trying to mount with the new syntax.
> > > 
> > > Signed-off-by: Venky Shankar <vshankar@redhat.com>
> > > ---
> > >  fs/ceph/super.c | 117 +++++++++++++++++++++++++++++++++++++++++++-----
> > >  fs/ceph/super.h |   3 ++
> > >  2 files changed, 110 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > > index 9b1b7f4cfdd4..950a28ad9c59 100644
> > > --- a/fs/ceph/super.c
> > > +++ b/fs/ceph/super.c
> > > @@ -145,6 +145,7 @@ enum {
> > >       Opt_mds_namespace,
> > >       Opt_recover_session,
> > >       Opt_source,
> > > +     Opt_mon_addr,
> > >       /* string args above */
> > >       Opt_dirstat,
> > >       Opt_rbytes,
> > > @@ -196,6 +197,7 @@ static const struct fs_parameter_spec ceph_mount_parameters[] = {
> > >       fsparam_u32     ("rsize",                       Opt_rsize),
> > >       fsparam_string  ("snapdirname",                 Opt_snapdirname),
> > >       fsparam_string  ("source",                      Opt_source),
> > > +     fsparam_string  ("mon_addr",                    Opt_mon_addr),
> > >       fsparam_u32     ("wsize",                       Opt_wsize),
> > >       fsparam_flag_no ("wsync",                       Opt_wsync),
> > >       {}
> > > @@ -226,10 +228,68 @@ static void canonicalize_path(char *path)
> > >       path[j] = '\0';
> > >  }
> > > 
> > > +static int ceph_parse_old_source(const char *dev_name, const char *dev_name_end,
> > > +                              struct fs_context *fc)
> > > +{
> > > +     int r;
> > > +     struct ceph_parse_opts_ctx *pctx = fc->fs_private;
> > > +     struct ceph_mount_options *fsopt = pctx->opts;
> > > +
> > > +     if (*dev_name_end != ':')
> > > +             return invalfc(fc, "separator ':' missing in source");
> > > +
> > > +     r = ceph_parse_mon_ips(dev_name, dev_name_end - dev_name,
> > > +                            pctx->copts, fc->log.log);
> > > +     if (r)
> > > +             return r;
> > > +
> > > +     fsopt->new_dev_syntax = false;
> > > +     return 0;
> > > +}
> > > +
> > > +static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
> > > +                              struct fs_context *fc)
> > > +{
> > > +     struct ceph_parse_opts_ctx *pctx = fc->fs_private;
> > > +     struct ceph_mount_options *fsopt = pctx->opts;
> > > +     char *fsid_start, *fs_name_start;
> > > +
> > > +     if (*dev_name_end != '=')
> > > +                return invalfc(fc, "separator '=' missing in source");
> > 
> > An annoying thing is that we'll always see this error message when falling
> > back to the old_source method.
> > 

True. I'd rather this fallback be silent.

> > (Also, is there a good reason for using '=' instead of ':'?  I probably
> > missed this discussion somewhere else already...)
> > 

Yes, we needed a way for the kernel to distinguish between the old and
new syntax. Old kernels already reject any mount string without ":/" in
it, so we needed the new format to _not_ have that to ensure a clean
fallback procedure.

It's not as pretty as I would have liked, but it's starting to grow on
me. :)

> > > +
> > > +     fsid_start = strchr(dev_name, '@');
> > > +     if (!fsid_start)
> > > +             return invalfc(fc, "missing cluster fsid");
> > > +     ++fsid_start; /* start of cluster fsid */
> > > +
> > > +     fs_name_start = strchr(fsid_start, '.');
> > > +     if (!fs_name_start)
> > > +             return invalfc(fc, "missing file system name");
> > > +
> > > +     ++fs_name_start; /* start of file system name */
> > > +     fsopt->mds_namespace = kstrndup(fs_name_start,
> > > +                                     dev_name_end - fs_name_start, GFP_KERNEL);
> > > +     if (!fsopt->mds_namespace)
> > > +             return -ENOMEM;
> > > +     dout("file system (mds namespace) '%s'\n", fsopt->mds_namespace);
> > > +
> > > +     fsopt->new_dev_syntax = true;
> > > +     return 0;
> > > +}
> > > +
> > >  /*
> > > - * Parse the source parameter.  Distinguish the server list from the path.
> > > + * Parse the source parameter for new device format. Distinguish the device
> > > + * spec from the path. Try parsing new device format and fallback to old
> > > + * format if needed.
> > >   *
> > > - * The source will look like:
> > > + * New device syntax will looks like:
> > > + *     <device_spec>=/<path>
> > > + * where
> > > + *     <device_spec> is name@fsid.fsname
> > > + *     <path> is optional, but if present must begin with '/'
> > > + * (monitor addresses are passed via mount option)
> > > + *
> > > + * Old device syntax is:
> > >   *     <server_spec>[,<server_spec>...]:[<path>]
> > >   * where
> > >   *     <server_spec> is <ip>[:<port>]
> > > @@ -262,22 +322,48 @@ static int ceph_parse_source(struct fs_parameter *param, struct fs_context *fc)
> > >               dev_name_end = dev_name + strlen(dev_name);
> > >       }
> > > 
> > > -     dev_name_end--;         /* back up to ':' separator */
> > > -     if (dev_name_end < dev_name || *dev_name_end != ':')
> > > -             return invalfc(fc, "No path or : separator in source");
> > > +     dev_name_end--;         /* back up to separator */
> > > +     if (dev_name_end < dev_name)
> > > +             return invalfc(fc, "path missing in source");
> > > 
> > >       dout("device name '%.*s'\n", (int)(dev_name_end - dev_name), dev_name);
> > >       if (fsopt->server_path)
> > >               dout("server path '%s'\n", fsopt->server_path);
> > > 
> > > -     ret = ceph_parse_mon_ips(param->string, dev_name_end - dev_name,
> > > -                              pctx->copts, fc->log.log);
> > > +     dout("trying new device syntax");
> > > +     ret = ceph_parse_new_source(dev_name, dev_name_end, fc);
> > > +     if (ret == 0)
> > > +             goto done;
> > > +
> > > +     dout("trying old device syntax");
> > > +     ret = ceph_parse_old_source(dev_name, dev_name_end, fc);
> > >       if (ret)
> > > -             return ret;
> > > +             goto out;
> > > 
> > > + done:
> > >       fc->source = param->string;
> > >       param->string = NULL;
> > > -     return 0;
> > > + out:
> > > +     return ret;
> > > +}
> > > +
> > > +static int ceph_parse_mon_addr(struct fs_parameter *param,
> > > +                            struct fs_context *fc)
> > > +{
> > > +     int r;
> > > +     struct ceph_parse_opts_ctx *pctx = fc->fs_private;
> > > +     struct ceph_mount_options *fsopt = pctx->opts;
> > > +
> > > +     kfree(fsopt->mon_addr);
> > > +     fsopt->mon_addr = kstrdup(param->string, GFP_KERNEL);
> > > +     if (!fsopt->mon_addr)
> > > +             return -ENOMEM;
> > > +
> > > +     strreplace(param->string, '/', ',');
> > > +     r = ceph_parse_mon_ips(param->string, strlen(param->string),
> > > +                            pctx->copts, fc->log.log);
> > > +     param->string = NULL;
> > 
> > I think this will result in a memory leak.  Why don't we simply set
> > fsopt->mon_addr to param->string instead of kstrdup'ing it?
> 
> Sure. As discussed over irc, will do away with the alloc.
> 
> > 
> > Cheers,
> > --
> > Luís
> > 
> > > +     return r;
> > >  }
> > > 
> > >  static int ceph_parse_mount_param(struct fs_context *fc,
> > > @@ -322,6 +408,8 @@ static int ceph_parse_mount_param(struct fs_context *fc,
> > >               if (fc->source)
> > >                       return invalfc(fc, "Multiple sources specified");
> > >               return ceph_parse_source(param, fc);
> > > +     case Opt_mon_addr:
> > > +             return ceph_parse_mon_addr(param, fc);
> > >       case Opt_wsize:
> > >               if (result.uint_32 < PAGE_SIZE ||
> > >                   result.uint_32 > CEPH_MAX_WRITE_SIZE)
> > > @@ -473,6 +561,7 @@ static void destroy_mount_options(struct ceph_mount_options *args)
> > >       kfree(args->mds_namespace);
> > >       kfree(args->server_path);
> > >       kfree(args->fscache_uniq);
> > > +     kfree(args->mon_addr);
> > >       kfree(args);
> > >  }
> > > 
> > > @@ -516,6 +605,10 @@ static int compare_mount_options(struct ceph_mount_options *new_fsopt,
> > >       if (ret)
> > >               return ret;
> > > 
> > > +     ret = strcmp_null(fsopt1->mon_addr, fsopt2->mon_addr);
> > > +     if (ret)
> > > +             return ret;
> > > +
> > >       return ceph_compare_options(new_opt, fsc->client);
> > >  }
> > > 
> > > @@ -571,9 +664,13 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
> > >       if ((fsopt->flags & CEPH_MOUNT_OPT_NOCOPYFROM) == 0)
> > >               seq_puts(m, ",copyfrom");
> > > 
> > > -     if (fsopt->mds_namespace)
> > > +     /* dump mds_namespace when old device syntax is in use */
> > > +     if (fsopt->mds_namespace && !fsopt->new_dev_syntax)
> > >               seq_show_option(m, "mds_namespace", fsopt->mds_namespace);
> > > 
> > > +     if (fsopt->mon_addr)
> > > +             seq_printf(m, ",mon_addr=%s", fsopt->mon_addr);
> > > +
> > >       if (fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)
> > >               seq_show_option(m, "recover_session", "clean");
> > > 
> > > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > > index 839e6b0239ee..557348ff3203 100644
> > > --- a/fs/ceph/super.h
> > > +++ b/fs/ceph/super.h
> > > @@ -88,6 +88,8 @@ struct ceph_mount_options {
> > >       unsigned int max_readdir;       /* max readdir result (entries) */
> > >       unsigned int max_readdir_bytes; /* max readdir result (bytes) */
> > > 
> > > +     bool new_dev_syntax;
> > > +
> > >       /*
> > >        * everything above this point can be memcmp'd; everything below
> > >        * is handled in compare_mount_options()
> > > @@ -97,6 +99,7 @@ struct ceph_mount_options {
> > >       char *mds_namespace;  /* default NULL */
> > >       char *server_path;    /* default NULL (means "/") */
> > >       char *fscache_uniq;   /* default NULL */
> > > +     char *mon_addr;
> > >  };
> > > 
> > >  struct ceph_fs_client {
> > > --
> > > 2.27.0
> > > 
> > 
> 
> 

-- 
Jeff Layton <jlayton@redhat.com>

