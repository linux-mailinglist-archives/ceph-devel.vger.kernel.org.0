Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D3243B5A4
	for <lists+ceph-devel@lfdr.de>; Tue, 26 Oct 2021 17:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236859AbhJZPdy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 26 Oct 2021 11:33:54 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:49032 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbhJZPdy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 26 Oct 2021 11:33:54 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 71457218EE;
        Tue, 26 Oct 2021 15:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635262289; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WRaS7nJzrR8Imfw5d0ZNw+6zjdxIKCzj8dbxpPfA/HM=;
        b=lDpCN6Bo6deYWNj0WHNQAInx1yVgZJdjHE2q7t7RQUmko4wr/18/tAkdMKao1HfrSZ6Gih
        IXTuKwrFFNhpVaFYFgKSqk+yKoYVk4PI5iOrUlaH0xOPvONq/dDwI4xao2MdR4LHcVQqil
        fcFRLUkeOmq5wfRRBmHMzyL8BSo8wzQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635262289;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WRaS7nJzrR8Imfw5d0ZNw+6zjdxIKCzj8dbxpPfA/HM=;
        b=Kht/G5H7YMoHA0zhEwv9vVMYYC9Z6a2YMeExQFrAPrK0aCmGCUYOHpMc1pdNBWTvY6Oo8X
        QAKdMnrwbLVWhACQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 08C2713B0A;
        Tue, 26 Oct 2021 15:31:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mJTIOlAfeGGSNQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 26 Oct 2021 15:31:28 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 02f16863;
        Tue, 26 Oct 2021 15:31:28 +0000 (UTC)
Date:   Tue, 26 Oct 2021 16:31:28 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Xiubo Li <xiubli@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] ceph: add remote object copy counter to fs client
Message-ID: <YXgfUJ9aYrubADRQ@suse.de>
References: <20211020143708.14728-1-lhenriques@suse.de>
 <34e379f9dec1cbdf09fffd8207f6ef7f4e1a6841.camel@kernel.org>
 <CA+2bHPbqeH_rmmxcnQ9gq0K8gqtE4q69a8cFnherSJCxSwXV5Q@mail.gmail.com>
 <99209198dd9d8634245f153a90e4091851635a16.camel@kernel.org>
 <CA+2bHPZTazVGtZygdbthQ-AWiC3AN_hsYouhVVs=PDo5iowgTw@mail.gmail.com>
 <e5627f7d9eb9cf2b753136e1187d5d6ff7789389.camel@kernel.org>
 <CA+2bHPYacg5yjO9otP5wUVxgwxw+d4hroVQod5VeFUTJNosQ9w@mail.gmail.com>
 <785d1435-4a2c-95aa-0573-2de54b4e7b6b@redhat.com>
 <604199ed389d9286e3fdab6b5acdf65c421df45d.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <604199ed389d9286e3fdab6b5acdf65c421df45d.camel@kernel.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Oct 26, 2021 at 07:40:51AM -0400, Jeff Layton wrote:
> On Tue, 2021-10-26 at 11:05 +0800, Xiubo Li wrote:
> > On 10/22/21 1:30 AM, Patrick Donnelly wrote:
> > > On Thu, Oct 21, 2021 at 12:35 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > On Thu, 2021-10-21 at 12:18 -0400, Patrick Donnelly wrote:
> > > > > On Thu, Oct 21, 2021 at 11:44 AM Jeff Layton <jlayton@kernel.org> wrote:
> > > > > > On Thu, 2021-10-21 at 09:52 -0400, Patrick Donnelly wrote:
> > > > > > > On Wed, Oct 20, 2021 at 12:27 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > > > > > On Wed, 2021-10-20 at 15:37 +0100, Luís Henriques wrote:
> > > > > > > > > This counter will keep track of the number of remote object copies done on
> > > > > > > > > copy_file_range syscalls.  This counter will be filesystem per-client, and
> > > > > > > > > can be accessed from the client debugfs directory.
> > > > > > > > > 
> > > > > > > > > Cc: Patrick Donnelly <pdonnell@redhat.com>
> > > > > > > > > Signed-off-by: Luís Henriques <lhenriques@suse.de>
> > > > > > > > > ---
> > > > > > > > > This is an RFC to reply to Patrick's request in [0].  Note that I'm not
> > > > > > > > > 100% sure about the usefulness of this patch, or if this is the best way
> > > > > > > > > to provide the functionality Patrick requested.  Anyway, this is just to
> > > > > > > > > get some feedback, hence the RFC.
> > > > > > > > > 
> > > > > > > > > Cheers,
> > > > > > > > > --
> > > > > > > > > Luís
> > > > > > > > > 
> > > > > > > > > [0] https://github.com/ceph/ceph/pull/42720
> > > > > > > > > 
> > > > > > > > I think this would be better integrated into the stats infrastructure.
> > > > > > > > 
> > > > > > > > Maybe you could add a new set of "copy" stats to struct
> > > > > > > > ceph_client_metric that tracks the total copy operations done, their
> > > > > > > > size and latency (similar to read and write ops)?
> > > > > > > I think it's a good idea to integrate this into "stats" but I think a
> > > > > > > local debugfs file for some counters is still useful. The "stats"
> > > > > > > module is immature at this time and I'd rather not build any qa tests
> > > > > > > (yet) that rely on it.
> > > > > > > 
> > > > > > > Can we generalize this patch-set to a file named "op_counters" or
> > > > > > > similar and additionally add other OSD ops performed by the kclient?
> > > > > > > 
> > > > > > 
> > > > > > Tracking this sort of thing is the main purpose of the stats code. I'm
> > > > > > really not keen on adding a whole separate set of files for reporting
> > > > > > this.
> > > > > Maybe I'm confused. Is there some "file" which is already used for
> > > > > this type of debugging information? Or do you mean the code for
> > > > > sending stats to the MDS to support cephfs-top?
> > > > > 
> > > > > > What's the specific problem with relying on the data in debugfs
> > > > > > "metrics" file?
> > > > > Maybe no problem? I wasn't aware of a "metrics" file.
> > > > > 
> > > > Yes. For instance:
> > > > 
> > > > # cat /sys/kernel/debug/ceph/*/metrics
> > > > item                               total
> > > > ------------------------------------------
> > > > opened files  / total inodes       0 / 4
> > > > pinned i_caps / total inodes       5 / 4
> > > > opened inodes / total inodes       0 / 4
> > > > 
> > > > item          total       avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)
> > > > -----------------------------------------------------------------------------------
> > > > read          0           0               0               0               0
> > > > write         5           914013          824797          1092343         103476
> > > > metadata      79          12856           1572            114572          13262
> > > > 
> > > > item          total       avg_sz(bytes)   min_sz(bytes)   max_sz(bytes)  total_sz(bytes)
> > > > ----------------------------------------------------------------------------------------
> > > > read          0           0               0               0               0
> > > > write         5           4194304         4194304         4194304         20971520
> > > > 
> > > > item          total           miss            hit
> > > > -------------------------------------------------
> > > > d_lease       11              0               29
> > > > caps          5               68              10702
> > > > 
> > > > 
> > > > I'm proposing that Luis add new lines for "copy" to go along with the
> > > > "read" and "write" ones. The "total" counter should give you a count of
> > > > the number of operations.
> > > Okay that makes more sense!
> > > 
> > > Side note: I am a bit horrified by how computer-unfriendly that
> > > table-formatted data is.
> > 
> > Any suggestion to improve this ?
> > 
> > How about just make the "metric" file writable like a switch ? And as 
> > default it will show the data as above and if tools want the 
> > computer-friendly format, just write none-zero to it, then show raw data 
> > just like:
> > 
> > # cat /sys/kernel/debug/ceph/*/metrics
> > opened_files:0
> > pinned_i_caps:5
> > opened_inodes:0
> > total_inodes:4
> > 
> > read_latency:0,0,0,0,0
> > write_latency:5,914013,824797,1092343,103476
> > metadata_latency:79,12856,1572,114572,13262
> > 
> > read_size:0,0,0,0,0
> > write_size:5,4194304,4194304,4194304,20971520
> > 
> > d_lease:11,0,29
> > caps:5,68,10702
> > 
> > 
> 
> I'd rather not multiplex the output of this file based on some input.
> That would also be rather hard to do -- write() and read() are two
> different syscalls, so you'd need to track a bool (or something) across
> them somehow.
> 
> Currently, I doubt there are many scripts in the field that scrape this
> info and debugfs is specifically excluded from ABI concerns. If we want
> to make it more machine-readable (which sounds like a good thing), then
> I suggest we just change the output to something like what you have
> above and not worry about preserving the "legacy" output.

Ok, before submitting any new revision of this patch I should probably
clean this up.  I can submit a patch to change the format to what Xiubo is
proposing.  Obviously, that patch will also need to document what all
those fields actually mean.

Alternatively, the metrics file could be changed into a directory and have
4 different files, one per each section:

  metrics/
   |- files <-- not sure how to name the 1st section
   |- latency
   |- size
   \- caps

Each of these files would then have the header but, since it's a single
header, parsing it in a script would be pretty easy.  The advantage is
that this would be self-documented (with filenames and headers).

Cheers,
--
Luís
