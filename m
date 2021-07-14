Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECFF3C8A99
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Jul 2021 20:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhGNSSs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 14 Jul 2021 14:18:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23224 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229990AbhGNSSs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 14 Jul 2021 14:18:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626286556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YBvvRT2Gz1+uZ2GrZlLdzThJ6/7CBll+WuW5fcy9PXU=;
        b=gRvfQm+mwIocshf7g3EVBofIOiyyNhWomzCzDv5qv3EY87nB54ky+hC4Cv0vaxzD72yCVz
        mpmlgcHy2GVDUsqqmG8gejtMosZUuBL7ishNKuDiCDM3r64lItOp7RL6Z4IMuR8D8tdphs
        eNGgXT+bgCaBfzcXg3AfCokq8T2rm6c=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211--XiGfa5INbaFmETXnH4kGg-1; Wed, 14 Jul 2021 14:15:52 -0400
X-MC-Unique: -XiGfa5INbaFmETXnH4kGg-1
Received: by mail-qk1-f200.google.com with SMTP id c3-20020a37b3030000b02903ad0001a2e8so1883643qkf.3
        for <ceph-devel@vger.kernel.org>; Wed, 14 Jul 2021 11:15:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=YBvvRT2Gz1+uZ2GrZlLdzThJ6/7CBll+WuW5fcy9PXU=;
        b=F6QnJFr4aIJeIa3Ng4ij/F9Enyj4zI6xILZKG6J7UhMqoaseR7Gi/bQbu3U3hozHxo
         zQE4lNRzioR+rxdQAvZV6S1fMKeYmSDU4MZZLn8DPZlgT79o30UdMl5DM0YP553tg5e6
         k45AQgo5FpBhVOfYxbUlS1NDBiI9SRDZKwCHrCznfWEPqLNRkXcS8PNlUVOF2oXYYR5c
         gM0CVnJBDiajZ5XMhkWG2qLn6IRHx4V5njzYA0QgzKAz4Fhm+7556xENqy1u16eNZ/0E
         StqjHTJHmh+WbGIuuVpSgTzS2pJJf9iwhhhxYbz8RAzHnY9Jbz7Z6Sn9nNM/NhpkOI1g
         0lkA==
X-Gm-Message-State: AOAM5329ngA3v6ZK1sK8Scx1vpOHB4GHhmkmR3uA0+panX3iEcU0HWPa
        Pc9EKLfyj5JP51jucKTZaXzr2lH6F5au4RxFafRdOe4HJSD63FSuvXkCJ6jHw13drx7EHOkzT4W
        jgwR25xKS71/CpmkXHTKkuA==
X-Received: by 2002:a37:ae05:: with SMTP id x5mr11337084qke.321.1626286551161;
        Wed, 14 Jul 2021 11:15:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPy43t6wioa9P+JzH9cv5UShbG7bZODI6jaTpOC85kQYlILXIRpqAF9U9gVk90vZUBJla+yA==
X-Received: by 2002:a37:ae05:: with SMTP id x5mr11337064qke.321.1626286550950;
        Wed, 14 Jul 2021 11:15:50 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id o66sm1402347qkd.60.2021.07.14.11.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 11:15:50 -0700 (PDT)
Message-ID: <eefa9ad5fa2b8a1e20a2031d622024151240ba70.camel@redhat.com>
Subject: Re: [PATCH v4 4/5] ceph: record updated mon_addr on remount
From:   Jeff Layton <jlayton@redhat.com>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     Venky Shankar <vshankar@redhat.com>, idryomov@gmail.com,
        Xiubo Li <xiubli@redhat.com>, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Wed, 14 Jul 2021 14:15:50 -0400
In-Reply-To: <YO8SZ+Q3LaCt3K+V@suse.de>
References: <20210714100554.85978-1-vshankar@redhat.com>
         <20210714100554.85978-5-vshankar@redhat.com>
         <848d919c6a791ab9b7c61d7cb89f759b55195c18.camel@redhat.com>
         <YO8SZ+Q3LaCt3K+V@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-07-14 at 17:35 +0100, Luis Henriques wrote:
> On Wed, Jul 14, 2021 at 12:17:33PM -0400, Jeff Layton wrote:
> > On Wed, 2021-07-14 at 15:35 +0530, Venky Shankar wrote:
> > > Note that the new monitors are just shown in /proc/mounts.
> > > Ceph does not (re)connect to new monitors yet.
> > > 
> > > Signed-off-by: Venky Shankar <vshankar@redhat.com>
> > > ---
> > >  fs/ceph/super.c | 7 +++++++
> > >  1 file changed, 7 insertions(+)
> > > 
> > > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > > index d8c6168b7fcd..d3a5a3729c5b 100644
> > > --- a/fs/ceph/super.c
> > > +++ b/fs/ceph/super.c
> > > @@ -1268,6 +1268,13 @@ static int ceph_reconfigure_fc(struct fs_context *fc)
> > >  	else
> > >  		ceph_clear_mount_opt(fsc, ASYNC_DIROPS);
> > >  
> > > +	if (strcmp(fsc->mount_options->mon_addr, fsopt->mon_addr)) {
> > > +		kfree(fsc->mount_options->mon_addr);
> > > +		fsc->mount_options->mon_addr = fsopt->mon_addr;
> > > +		fsopt->mon_addr = NULL;
> > > +		printk(KERN_NOTICE "ceph: monitor addresses recorded, but not used for reconnection");
> > 
> > It's currently more in-vogue to use pr_notice() for this. I'll plan to
> > make that (minor) change before I merge. No need to resend.
> 
> Yeah, this was the only comment I had too.  I saw some issues in the
> previous revision but the changes to ceph_parse_source() seem to fix it in
> this revision.
> 
> The other annoying thing I found isn't related with this patchset but with
> a change that's been done some time ago by Xiubo (added to CC): it looks
> like that if we have an invalid parameter (for example, wrong secret)
> we'll always get -EHOSTUNREACH.
> 
> See below a possible fix (although I'm not entirely sure that's the correct
> one).
> 
> Cheers,
> --
> Luís
> 
> From a988d24d8e72fc4933459f3dd5d303cbc9a566ed Mon Sep 17 00:00:00 2001
> From: Luis Henriques <lhenriques@suse.de>
> Date: Wed, 14 Jul 2021 16:56:36 +0100
> Subject: [PATCH] ceph: don't hide error code if we don't have mdsmap
> 
> Since commit 97820058fb28 ("ceph: check availability of mds cluster on mount
> after wait timeout") we're returning -EHOSTUNREACH, even if the error isn't
> related with the MDSs availability.  For example, we'll get it even if we're
> trying to mounting a filesystem with an invalid username or secret.
> 
> Only return this error if we get -EIO.
> 
> Fixes: 97820058fb28 ("ceph: check availability of mds cluster on mount after wait timeout")
> Signed-off-by: Luis Henriques <lhenriques@suse.de>
> ---
>  fs/ceph/super.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 086a1ceec9d8..67d70059ce9f 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -1230,7 +1230,8 @@ static int ceph_get_tree(struct fs_context *fc)
>  	return 0;
>  
>  out_splat:
> -	if (!ceph_mdsmap_is_cluster_available(fsc->mdsc->mdsmap)) {
> +	if ((err == -EIO) &&
> +	    !ceph_mdsmap_is_cluster_available(fsc->mdsc->mdsmap)) {
>  		pr_info("No mds server is up or the cluster is laggy\n");
>  		err = -EHOSTUNREACH;
>  	}

Yeah, I've noticed that message pop up under all sorts of circumstances
and it is an annoyance. I'm happy to consider such a patch if you send
it separately.

That said, I'm honestly not sure this message is really helpful, and
overriding errors like this at a high level seems sort of sketchy. Maybe
we should just drop that message, or figure out a way to limit it to
_just_ that situation.

--
Jeff Layton <jlayton@redhat.com>

