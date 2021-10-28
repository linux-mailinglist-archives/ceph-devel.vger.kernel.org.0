Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1666F43E3ED
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Oct 2021 16:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhJ1Okb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Oct 2021 10:40:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231299AbhJ1Ok3 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 10:40:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D63360F9B;
        Thu, 28 Oct 2021 14:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635431882;
        bh=nb7hadX1IVa2oFNbJtHdb0jVHNwL2nVEwRk4XRPlPVI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gDtAMnHadk+rxLKs7JSehz6T6fcbvujYbj1tMLbOy5ZV4NnBTLHUC/KRmArx8Unqm
         Un/q7InN6qkDNf0WdZ+76tR+lnouF9cUzO5mzHF5p/E8r7syJWOvwuE9u6GZfpLxPq
         u/Wh7bfsJdYGlznncVaOgqh1/l/adjD6GDzxwov1Tzv3VRYwSZeL0cGpRAY0fC9k9Q
         bNn+lT5iDHTBqTbT1S2tzCo9lUmy4HzVMEhBVdpFicGllyZ5jKvz0MGDBrrbfhd7cK
         4EzrkKE0yy+0SeHEp3/77oTvpWetYTFEFWbvsv2xrr69uh6UdCPjFIx3kktKuUxn6u
         Tv5gD8bqq7STg==
Message-ID: <d13f3f13eda6f9d73e0754db3238f27aaa7f2e85.camel@kernel.org>
Subject: Re: [RFC PATCH v3] ceph: ceph: add remote object copies to fs
 client metrics
From:   Jeff Layton <jlayton@kernel.org>
To:     =?ISO-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Cc:     Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Patrick Donnelly <pdonnell@redhat.com>
Date:   Thu, 28 Oct 2021 10:38:01 -0400
In-Reply-To: <YXqy1rRu9hDS72Cx@suse.de>
References: <20211028114826.27192-1-lhenriques@suse.de>
         <06ef4f08edebf8b0a1a8660adfc46597d0d028b7.camel@kernel.org>
         <YXqy1rRu9hDS72Cx@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-10-28 at 15:25 +0100, Luís Henriques wrote:
> On Thu, Oct 28, 2021 at 08:41:52AM -0400, Jeff Layton wrote:
> > On Thu, 2021-10-28 at 12:48 +0100, Luís Henriques wrote:
> > > This patch adds latency and size metrics for remote object copies
> > > operations ("copyfrom").  For now, these metrics will be available on the
> > > client only, they won't be sent to the MDS.
> > > 
> > > Cc: Patrick Donnelly <pdonnell@redhat.com>
> > > Signed-off-by: Luís Henriques <lhenriques@suse.de>
> > > ---
> > > This patch is still an RFC because it is... ugly.  Although it now
> > > provides nice values (latency and size) using the metrics infrastructure,
> > > it actually needs to extend the ceph_osdc_copy_from() function to add 2
> > > extra args!  That's because we need to get the timestamps stored in
> > > ceph_osd_request, which is handled within that function.
> > > 
> > > The alternative is to ignore those timestamps and collect new ones in
> > > ceph_do_objects_copy():
> > > 
> > > 	start_req = ktime_get();
> > > 	ceph_osdc_copy_from(...);
> > > 	end_req = ktime_get();
> > > 
> > > These would be more coarse-grained, of course.  Any other suggestions?
> > > 
> > 
> > Not really. It is definitely ugly, I'll grant you that though...
> > 
> > The cleaner method might be to just inline ceph_osdc_copy_from in
> > ceph_do_objects_copy so that you deal with the req in there.
> 
> Yeah, but the reason for having these 2 functions was to keep net/ceph/
> code free from cephfs-specific code.  Inlining ceph_osdc_copy_from would
> need to bring some extra FS knowledge into libceph.ko.  Right now the
> funcion in osd_client receives only the required args for doing a copyfrom
> operation.  (But TBH it's possible that libceph already contains several
> bits that are cephfs or rbd specific.)
> 


Oh, I was more just suggesting that you just copy the guts out of
ceph_osdc_copy_from() and paste them into the only caller
(ceph_do_objects_copy). That would give you access to the OSD req field
in ceph_do_objects_copy and you could just copy the appropriate fields
there.


> However, I just realized that I do have some code here that changes
> ceph_osdc_copy_from() to return the OSD req struct.  The caller would then
> be responsible for doing the ceph_osdc_wait_request().  This code was from
> my copy_file_range parallelization patch (which I should revisit one of
> these days), but could be reused here.  Do you think it would be
> acceptable?
> 

Yeah, that would work too. The problem you have is that the OSD request
is driven by ceph_osdc_copy_from, and you probably want to do that in
ceph_do_objects_copy instead so you can get to the timestamp fields.

> <...>
> > > +	spinlock_t copyfrom_metric_lock;
> > > +	u64 total_copyfrom;
> > > +	u64 copyfrom_size_sum;
> > > +	u64 copyfrom_size_min;
> > > +	u64 copyfrom_size_max;
> > > +	ktime_t copyfrom_latency_sum;
> > > +	ktime_t copyfrom_latency_sq_sum;
> > > +	ktime_t copyfrom_latency_min;
> > > +	ktime_t copyfrom_latency_max;
> > > +
> > 
> > Not a comment about your patch, specifically, but we have a lot of
> > copy/pasted code to deal with different parts of ceph_client_metric.
> > 
> > It might be nice to eventually turn each of the read/write/copy metric
> > blocks in this struct into an array, and collapse a lot of the other
> > helper functions together.
> > 
> > If you feel like doing that cleanup, I'd be happy to review. Otherwise,
> > I'll plan to look at it in the near future.
> 
> Yeah, sure.  I can have a look at that too.
> 
> Cheers,
> --
> Luís

-- 
Jeff Layton <jlayton@kernel.org>

