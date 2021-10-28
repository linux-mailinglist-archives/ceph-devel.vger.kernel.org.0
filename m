Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7ADF43E39C
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Oct 2021 16:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhJ1O2B (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Oct 2021 10:28:01 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:57062 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbhJ1O2B (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 28 Oct 2021 10:28:01 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5DA021FD53;
        Thu, 28 Oct 2021 14:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635431133; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z8HFzhLPeMNEIpymtY0aL1CjyagQsMTGZ46Z+UL1840=;
        b=k2D/G9+AULYYNXqvPfX4mVCOkk8d0zBoamjfB/CPWzUlYA/JhdQztIClekKMThoxv5Uqzh
        854ccBKhpjKEQfy2ZRnYIRXjVo+mL502jTBMoOY6/VqDnsD7xo2o/WrWPkJzmS7LJA3UHz
        51dBqFXAfEmNupZDQ1TXusD99bARikk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635431133;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z8HFzhLPeMNEIpymtY0aL1CjyagQsMTGZ46Z+UL1840=;
        b=ZhIhuVX2aPEFKw5sI9v9nRX42997oUUzEidx4H6yPFLPwe1jWxnK2KgozOqRgxCJpI32EN
        xMec8D6KPh/eFjDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F0AC113E9D;
        Thu, 28 Oct 2021 14:25:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 75yNN9yyemGbGwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Thu, 28 Oct 2021 14:25:32 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id b993446c;
        Thu, 28 Oct 2021 14:25:32 +0000 (UTC)
Date:   Thu, 28 Oct 2021 15:25:26 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Patrick Donnelly <pdonnell@redhat.com>
Subject: Re: [RFC PATCH v3] ceph: ceph: add remote object copies to fs client
 metrics
Message-ID: <YXqy1rRu9hDS72Cx@suse.de>
References: <20211028114826.27192-1-lhenriques@suse.de>
 <06ef4f08edebf8b0a1a8660adfc46597d0d028b7.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <06ef4f08edebf8b0a1a8660adfc46597d0d028b7.camel@kernel.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Oct 28, 2021 at 08:41:52AM -0400, Jeff Layton wrote:
> On Thu, 2021-10-28 at 12:48 +0100, Luís Henriques wrote:
> > This patch adds latency and size metrics for remote object copies
> > operations ("copyfrom").  For now, these metrics will be available on the
> > client only, they won't be sent to the MDS.
> > 
> > Cc: Patrick Donnelly <pdonnell@redhat.com>
> > Signed-off-by: Luís Henriques <lhenriques@suse.de>
> > ---
> > This patch is still an RFC because it is... ugly.  Although it now
> > provides nice values (latency and size) using the metrics infrastructure,
> > it actually needs to extend the ceph_osdc_copy_from() function to add 2
> > extra args!  That's because we need to get the timestamps stored in
> > ceph_osd_request, which is handled within that function.
> > 
> > The alternative is to ignore those timestamps and collect new ones in
> > ceph_do_objects_copy():
> > 
> > 	start_req = ktime_get();
> > 	ceph_osdc_copy_from(...);
> > 	end_req = ktime_get();
> > 
> > These would be more coarse-grained, of course.  Any other suggestions?
> > 
> 
> Not really. It is definitely ugly, I'll grant you that though...
> 
> The cleaner method might be to just inline ceph_osdc_copy_from in
> ceph_do_objects_copy so that you deal with the req in there.

Yeah, but the reason for having these 2 functions was to keep net/ceph/
code free from cephfs-specific code.  Inlining ceph_osdc_copy_from would
need to bring some extra FS knowledge into libceph.ko.  Right now the
funcion in osd_client receives only the required args for doing a copyfrom
operation.  (But TBH it's possible that libceph already contains several
bits that are cephfs or rbd specific.)

However, I just realized that I do have some code here that changes
ceph_osdc_copy_from() to return the OSD req struct.  The caller would then
be responsible for doing the ceph_osdc_wait_request().  This code was from
my copy_file_range parallelization patch (which I should revisit one of
these days), but could be reused here.  Do you think it would be
acceptable?

<...>
> > +	spinlock_t copyfrom_metric_lock;
> > +	u64 total_copyfrom;
> > +	u64 copyfrom_size_sum;
> > +	u64 copyfrom_size_min;
> > +	u64 copyfrom_size_max;
> > +	ktime_t copyfrom_latency_sum;
> > +	ktime_t copyfrom_latency_sq_sum;
> > +	ktime_t copyfrom_latency_min;
> > +	ktime_t copyfrom_latency_max;
> > +
> 
> Not a comment about your patch, specifically, but we have a lot of
> copy/pasted code to deal with different parts of ceph_client_metric.
> 
> It might be nice to eventually turn each of the read/write/copy metric
> blocks in this struct into an array, and collapse a lot of the other
> helper functions together.
> 
> If you feel like doing that cleanup, I'd be happy to review. Otherwise,
> I'll plan to look at it in the near future.

Yeah, sure.  I can have a look at that too.

Cheers,
--
Luís
