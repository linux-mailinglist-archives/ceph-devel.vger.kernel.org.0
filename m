Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B9A43E3BC
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Oct 2021 16:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbhJ1OcU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Oct 2021 10:32:20 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:36636 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbhJ1OcU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 28 Oct 2021 10:32:20 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 46EDD21974;
        Thu, 28 Oct 2021 14:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635431392; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fnQacjJrzF+VweZrVr7dh+1tn73gKyrFNWxwR+b7ei0=;
        b=ERg7um1WGG8zfpmDgP3TGle9Yf3ztkCuGEIZdoHS5dL8X0Vg8gW++cWhz0bVbtKrpAGSXA
        SsD9HwfkLiqDl96FWWT9xNDHiDiCmcjablNpmV58HR+Z1qn6oj4jdhPxsXEsQA45A+3MIG
        ryfQ24YTT7JBCqICf6KQPzgBKvtm400=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635431392;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fnQacjJrzF+VweZrVr7dh+1tn73gKyrFNWxwR+b7ei0=;
        b=CaHggJbrtI8oFFghRMpZCpZ6oyWWDWVl9lPuGFhbZPAtFama8SqP/REafP64RHFR4mJlUV
        Aa7ILBBGX8VOXaCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CB84513E9D;
        Thu, 28 Oct 2021 14:29:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id DomcLt+zemGuHQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Thu, 28 Oct 2021 14:29:51 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id b25d11a7;
        Thu, 28 Oct 2021 14:29:51 +0000 (UTC)
Date:   Thu, 28 Oct 2021 15:29:50 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Patrick Donnelly <pdonnell@redhat.com>
Subject: Re: [RFC PATCH v3] ceph: ceph: add remote object copies to fs client
 metrics
Message-ID: <YXqz3rCNrj2vsSwI@suse.de>
References: <20211028114826.27192-1-lhenriques@suse.de>
 <d80cc52c-4617-7941-c227-0465cbc8fc23@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d80cc52c-4617-7941-c227-0465cbc8fc23@redhat.com>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Oct 28, 2021 at 09:27:08PM +0800, Xiubo Li wrote:
> 
> On 10/28/21 7:48 PM, Luís Henriques wrote:
> > This patch adds latency and size metrics for remote object copies
> > operations ("copyfrom").  For now, these metrics will be available on the
> > client only, they won't be sent to the MDS.
> > 
> > Cc: Patrick Donnelly<pdonnell@redhat.com>
> > Signed-off-by: Luís Henriques<lhenriques@suse.de>
> > ---
> > This patch is still an RFC because it is... ugly.  Although it now
> > provides nice values (latency and size) using the metrics infrastructure,
> > it actually needs to extend the ceph_osdc_copy_from() function to add 2
> > extra args!  That's because we need to get the timestamps stored in
> > ceph_osd_request, which is handled within that function.
> > 
> > The alternative is to ignore those timestamps and collect new ones in
> > ceph_do_objects_copy():
> > 
> > 	start_req = ktime_get();
> > 	ceph_osdc_copy_from(...);
> > 	end_req = ktime_get();
> > 
> > These would be more coarse-grained, of course.  Any other suggestions?
> > 
> > Cheers,
> > -- Luís fs/ceph/debugfs.c | 19 ++++++++++++++++++ fs/ceph/file.c | 7
> > ++++++- fs/ceph/metric.c | 35 +++++++++++++++++++++++++++++++++
> > fs/ceph/metric.h | 14 +++++++++++++ include/linux/ceph/osd_client.h | 3
> > ++- net/ceph/osd_client.c | 8 ++++++-- 6 files changed, 82
> > insertions(+), 4 deletions(-) diff --git a/fs/ceph/debugfs.c
> > b/fs/ceph/debugfs.c index 55426514491b..b657170d6bc3 100644 ---
> > a/fs/ceph/debugfs.c +++ b/fs/ceph/debugfs.c @@ -203,6 +203,16 @@ static
> > int metrics_latency_show(struct seq_file *s, void *p)
> > spin_unlock(&m->metadata_metric_lock); CEPH_LAT_METRIC_SHOW("metadata",
> > total, avg, min, max, sq); + spin_lock(&m->copyfrom_metric_lock); +
> > total = m->total_copyfrom; + sum = m->copyfrom_latency_sum; + avg =
> > total > 0 ? DIV64_U64_ROUND_CLOSEST(sum, total) : 0; + min =
> > m->copyfrom_latency_min; + max = m->copyfrom_latency_max; + sq =
> > m->copyfrom_latency_sq_sum; + spin_unlock(&m->copyfrom_metric_lock); +
> > CEPH_LAT_METRIC_SHOW("copyfrom", total, avg, min, max, sq); + return 0;
> > } @@ -234,6 +244,15 @@ static int metrics_size_show(struct seq_file *s,
> > void *p) spin_unlock(&m->write_metric_lock);
> > CEPH_SZ_METRIC_SHOW("write", total, avg_sz, min_sz, max_sz, sum_sz); +
> > spin_lock(&m->copyfrom_metric_lock); + total = m->total_copyfrom; +
> > sum_sz = m->copyfrom_size_sum; + avg_sz = total > 0 ?
> > DIV64_U64_ROUND_CLOSEST(sum_sz, total) : 0; + min_sz =
> > m->copyfrom_size_min; + max_sz = m->copyfrom_size_max; +
> > spin_unlock(&m->copyfrom_metric_lock); + CEPH_SZ_METRIC_SHOW("copyfrom",
> > total, avg_sz, min_sz, max_sz, sum_sz); + return 0; } diff --git
> > a/fs/ceph/file.c b/fs/ceph/file.c index e61018d9764e..d1139bbcd58d
> > 100644 --- a/fs/ceph/file.c +++ b/fs/ceph/file.c @@ -2208,6 +2208,7 @@
> > static ssize_t ceph_do_objects_copy(struct ceph_inode_info *src_ci, u64
> > *src_off struct ceph_object_locator src_oloc, dst_oloc; struct
> > ceph_object_id src_oid, dst_oid; size_t bytes = 0; + ktime_t start_req,
> > end_req; u64 src_objnum, src_objoff, dst_objnum, dst_objoff; u32
> > src_objlen, dst_objlen; u32 object_size = src_ci->i_layout.object_size;
> > @@ -2242,7 +2243,11 @@ static ssize_t ceph_do_objects_copy(struct
> > ceph_inode_info *src_ci, u64 *src_off CEPH_OSD_OP_FLAG_FADVISE_DONTNEED,
> > dst_ci->i_truncate_seq, dst_ci->i_truncate_size, -
> > CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ); +
> > CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ, + &start_req, &end_req); +
> > ceph_update_copyfrom_metrics(&fsc->mdsc->metric, + start_req, end_req, +
> > object_size, ret);

(Ugh!  Your mail client completely messed-up the patch and took me a while
to figure out what you're suggesting :-) )

> Maybe you can move this to ceph_osdc_copy_from() by passing the object_size
> to it ?

I think this would mean to push into net/ceph/ more details about cephfs
(such as the knowledge about metrics).  Which I think we should avoid.
I've just suggested something different in my reply to Jeff, maybe that's
a better approach (basically, get the OSD request struct from
ceph_osdc_copy_from()).

Cheers,
--
Luís
