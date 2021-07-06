Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580103BDD53
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jul 2021 20:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhGFSiL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Jul 2021 14:38:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52777 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231231AbhGFSiK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Jul 2021 14:38:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625596531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GpQc0XMmeh6WejDS63VLNy/GnEPz4lhOPh4rtySQ+tY=;
        b=hqOJVn7GZ9t5IRmqp2XsaX4cek8UsWROG+S9mjjnKmthwnhwkrnPcC6arLhEmMKeMr3Bry
        ZFb8t/S9lFDpgKhFXnuKaYsWhnCpydpQFp9EtgWsy0ep4ZGAzJujHhl9l8dPp8HBcZAGUZ
        LL3Yi1yTJaEjHoF2ZdbHeGgaP+HTn6I=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-XW9u2W4EOZWSBF7ASDDc_A-1; Tue, 06 Jul 2021 14:35:30 -0400
X-MC-Unique: XW9u2W4EOZWSBF7ASDDc_A-1
Received: by mail-qt1-f200.google.com with SMTP id b11-20020ac812cb0000b0290250bfff0028so68571qtj.9
        for <ceph-devel@vger.kernel.org>; Tue, 06 Jul 2021 11:35:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=GpQc0XMmeh6WejDS63VLNy/GnEPz4lhOPh4rtySQ+tY=;
        b=TuCqjjOMaHyxzm7zT7PMTvcJ7X94GQK5L1ZBB79ujTyknLou75s0QJOjFjD4dUgolr
         ORSmhNYwWm5ujr7rBVVQ5PoyaHCsH68TRo29jtBHpWrs+LS7UdA8vNYPKOQLc7j0+Qd2
         8vJ+ehs3m+/H6ylMbOc4qZa7bdRwwRHlV7Ysgwm03LUoEjyJrclm3EiAOcecRFYvWk7v
         RmzGaGvDomINKNcFo2G70xyH57fUUy2ZLbKq4PQwG9Dehq805ym4o0RE5krbER/8bMUH
         RKMbgmcnOzJ4gPkQ2zPWpjMGmnL7BW9UaOuP+Tayx6R91MKeAikkYVtchJcbaTMin41+
         UI9g==
X-Gm-Message-State: AOAM532hbm74dj8B7YjpcHbeSbh7hPH20h3cUgi6JA7iV71teK4bfScC
        l35EIzt5gjnO9VCzlqQ2okPD1YqfVOccN4OsgrZIihI0BPAPTLt7CE5ix+uh1qJwtxSJ0bFpKcQ
        m9iPcqAzFF/1evnUmTnnwGg==
X-Received: by 2002:ad4:5ca6:: with SMTP id q6mr19726645qvh.23.1625596529855;
        Tue, 06 Jul 2021 11:35:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwAjHlfe8PfMwhu3cvK92C38HqplOlJDesd7OhbDkLzQ2DKPe2Ne4U3/pe4dY62vlVEOCTdvA==
X-Received: by 2002:ad4:5ca6:: with SMTP id q6mr19726618qvh.23.1625596529634;
        Tue, 06 Jul 2021 11:35:29 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id s6sm7335851qkc.125.2021.07.06.11.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 11:35:29 -0700 (PDT)
Message-ID: <b844de4ab0b086c7d2d824507bb27242c96f64b4.camel@redhat.com>
Subject: Re: [PATCH v2 2/4] ceph: validate cluster FSID for new device syntax
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>,
        Luis Henriques <lhenriques@suse.de>
Cc:     idryomov@gmail.com, Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Date:   Tue, 06 Jul 2021 14:35:28 -0400
In-Reply-To: <CACPzV1k6Wsym5sxb=3d3h-yMg2biJn=g9Ec-gzfi6CyF1xFJKg@mail.gmail.com>
References: <20210702064821.148063-1-vshankar@redhat.com>
         <20210702064821.148063-3-vshankar@redhat.com> <YN7t9TJlDG8YcbqM@suse.de>
         <CACPzV1=J_7n4kSjny-92OV2_rpWZn3fOK_sdHjJ6nnC9BgEOXw@mail.gmail.com>
         <YN8ZhNG0jiA2CFln@suse.de>
         <CACPzV1k6Wsym5sxb=3d3h-yMg2biJn=g9Ec-gzfi6CyF1xFJKg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2021-07-02 at 20:27 +0530, Venky Shankar wrote:
> On Fri, Jul 2, 2021 at 7:20 PM Luis Henriques <lhenriques@suse.de> wrote:
> > 
> > On Fri, Jul 02, 2021 at 04:40:18PM +0530, Venky Shankar wrote:
> > > On Fri, Jul 2, 2021 at 4:14 PM Luis Henriques <lhenriques@suse.de> wrote:
> > > > 
> > > > On Fri, Jul 02, 2021 at 12:18:19PM +0530, Venky Shankar wrote:
> > > > > The new device syntax requires the cluster FSID as part
> > > > > of the device string. Use this FSID to verify if it matches
> > > > > the cluster FSID we get back from the monitor, failing the
> > > > > mount on mismatch.
> > > > > 
> > > > > Also, rename parse_fsid() to ceph_parse_fsid() as it is too
> > > > > generic.
> > > > > 
> > > > > Signed-off-by: Venky Shankar <vshankar@redhat.com>
> > > > > ---
> > > > >  fs/ceph/super.c              | 9 +++++++++
> > > > >  fs/ceph/super.h              | 1 +
> > > > >  include/linux/ceph/libceph.h | 1 +
> > > > >  net/ceph/ceph_common.c       | 5 +++--
> > > > >  4 files changed, 14 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > > > > index 0b324e43c9f4..03e5f4bb2b6f 100644
> > > > > --- a/fs/ceph/super.c
> > > > > +++ b/fs/ceph/super.c
> > > > > @@ -268,6 +268,9 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
> > > > >       if (!fs_name_start)
> > > > >               return invalfc(fc, "missing file system name");
> > > > > 
> > > > > +     if (ceph_parse_fsid(fsid_start, &fsopt->fsid))
> > > > > +             return invalfc(fc, "invalid fsid format");
> > > > > +
> > > > >       ++fs_name_start; /* start of file system name */
> > > > >       fsopt->mds_namespace = kstrndup(fs_name_start,
> > > > >                                       dev_name_end - fs_name_start, GFP_KERNEL);
> > > > > @@ -750,6 +753,12 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
> > > > >       }
> > > > >       opt = NULL; /* fsc->client now owns this */
> > > > > 
> > > > > +     /* help learn fsid */
> > > > > +     if (fsopt->new_dev_syntax) {
> > > > > +             ceph_check_fsid(fsc->client, &fsopt->fsid);
> > > > 
> > > > This call to ceph_check_fsid() made me wonder what would happen if I use
> > > > the wrong fsid with the new syntax.  And the result is:
> > > > 
> > > > [   41.882334] libceph: mon0 (1)192.168.155.1:40594 session established
> > > > [   41.884537] libceph: bad fsid, had d52783e6-efc2-4dce-ad01-aa3272fa5f66 got 90bdb539-9d95-402e-8f23-b0e26cba8b1b
> > > > [   41.885955] libceph: bad fsid, had d52783e6-efc2-4dce-ad01-aa3272fa5f66 got 90bdb539-9d95-402e-8f23-b0e26cba8b1b
> > > > [   41.889313] libceph: bad fsid, had d52783e6-efc2-4dce-ad01-aa3272fa5f66 got 90bdb539-9d95-402e-8f23-b0e26cba8b1b
> > > > [   41.892578] libceph: osdc handle_map corrupt msg
> > > > 
> > > > ... followed by a msg dump.
> > > > 
> > > > I guess this means that manually setting the fsid requires changes to the
> > > > messenger (I've only tested with v1) so that it gracefully handles this
> > > > scenario.
> > > 
> > > Yes, this results in a big dump of messages. I haven't looked at
> > > gracefully handling these.
> > > 
> > > I'm not sure if it needs to be done in these set of patches though.
> > 
> > Ah, sure!  I didn't meant you'd need to change the messenger to handle it
> > (as I'm not even sure it's the messenger or the mons client that require
> > changes).  But I also don't think that this patchset can be merged without
> > making sure we can handle a bad fsid correctly and without all this noise.
> 
> True. However, for most cases users really won't be filling in the
> fsid and the mount helper would fill the "correct" one automatically.
> 

Yes, but some of them may and I think we do need to handle this
gracefully. Let's step back a moment and consider:

AIUI, the fsid is only here to disambiguate when you have multiple
clusters. The kernel doesn't really care about this value at all. All it
cares about is whether it's talking to the right mons (as evidenced by
the fact that we don't pass the fsid in at mount time today).

So probably the right thing to do is to just return an error (-EINVAL?)
to mount() when there is a mismatch between the fsid and the one in the
maps. Is that possible?

> > 
> > Cheers,
> > --
> > Luís
> > 
> > > 
> > > > 
> > > > Cheers,
> > > > --
> > > > Luís
> > > > 
> > > > > +             fsc->client->have_fsid = true;
> > > > > +     }
> > > > > +
> > > > >       fsc->client->extra_mon_dispatch = extra_mon_dispatch;
> > > > >       ceph_set_opt(fsc->client, ABORT_ON_FULL);
> > > > > 
> > > > > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > > > > index 8f71184b7c85..ce5fb90a01a4 100644
> > > > > --- a/fs/ceph/super.h
> > > > > +++ b/fs/ceph/super.h
> > > > > @@ -99,6 +99,7 @@ struct ceph_mount_options {
> > > > >       char *server_path;    /* default NULL (means "/") */
> > > > >       char *fscache_uniq;   /* default NULL */
> > > > >       char *mon_addr;
> > > > > +     struct ceph_fsid fsid;
> > > > >  };
> > > > > 
> > > > >  struct ceph_fs_client {
> > > > > diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
> > > > > index 409d8c29bc4f..75d059b79d90 100644
> > > > > --- a/include/linux/ceph/libceph.h
> > > > > +++ b/include/linux/ceph/libceph.h
> > > > > @@ -296,6 +296,7 @@ extern bool libceph_compatible(void *data);
> > > > >  extern const char *ceph_msg_type_name(int type);
> > > > >  extern int ceph_check_fsid(struct ceph_client *client, struct ceph_fsid *fsid);
> > > > >  extern void *ceph_kvmalloc(size_t size, gfp_t flags);
> > > > > +extern int ceph_parse_fsid(const char *str, struct ceph_fsid *fsid);
> > > > > 
> > > > >  struct fs_parameter;
> > > > >  struct fc_log;
> > > > > diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> > > > > index 97d6ea763e32..da480757fcca 100644
> > > > > --- a/net/ceph/ceph_common.c
> > > > > +++ b/net/ceph/ceph_common.c
> > > > > @@ -217,7 +217,7 @@ void *ceph_kvmalloc(size_t size, gfp_t flags)
> > > > >       return p;
> > > > >  }
> > > > > 
> > > > > -static int parse_fsid(const char *str, struct ceph_fsid *fsid)
> > > > > +int ceph_parse_fsid(const char *str, struct ceph_fsid *fsid)
> > > > >  {
> > > > >       int i = 0;
> > > > >       char tmp[3];
> > > > > @@ -247,6 +247,7 @@ static int parse_fsid(const char *str, struct ceph_fsid *fsid)
> > > > >       dout("parse_fsid ret %d got fsid %pU\n", err, fsid);
> > > > >       return err;
> > > > >  }
> > > > > +EXPORT_SYMBOL(ceph_parse_fsid);
> > > > > 
> > > > >  /*
> > > > >   * ceph options
> > > > > @@ -465,7 +466,7 @@ int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
> > > > >               break;
> > > > > 
> > > > >       case Opt_fsid:
> > > > > -             err = parse_fsid(param->string, &opt->fsid);
> > > > > +             err = ceph_parse_fsid(param->string, &opt->fsid);
> > > > >               if (err) {
> > > > >                       error_plog(&log, "Failed to parse fsid: %d", err);
> > > > >                       return err;
> > > > > --
> > > > > 2.27.0
> > > > > 
> > > > 
> > > 
> > > 
> > > --
> > > Cheers,
> > > Venky
> > > 
> > 
> 
> 

-- 
Jeff Layton <jlayton@redhat.com>

