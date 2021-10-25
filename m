Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8316043936A
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Oct 2021 12:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbhJYKOp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Oct 2021 06:14:45 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:37150 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbhJYKOo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 25 Oct 2021 06:14:44 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7C99A212C7;
        Mon, 25 Oct 2021 10:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635156741; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dB0FBmLwVXBQXW2FJZKxygSRayu1vt2IxCxFSfu5YEc=;
        b=y1tV3Sp2kvIsoylox4pssQzg62XmraJ7Ab0HCuqC9Md2CyZ8RWLYayggAWaYweQoTDWARX
        iMy6xjrMG8XTuNOA5jo+42ZoTEXQsJh4kdErJcf46TY1ECEBauGaOT/bJyHJP67YGEoY9H
        FSHMd1Cht5433TY8UkJnnUiBni6i27Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635156741;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dB0FBmLwVXBQXW2FJZKxygSRayu1vt2IxCxFSfu5YEc=;
        b=2PXh+OZbW19+NXR9HR4Y2gwCmt7gQp3ApyZxsRZdXCdGrprKJdgZy04K6RVVisPh+IDGa8
        M5O4vHnQ7KK5n+Cg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 23C4C13B95;
        Mon, 25 Oct 2021 10:12:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id uBMFBgWDdmH1ZgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 25 Oct 2021 10:12:21 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 0f24f1e9;
        Mon, 25 Oct 2021 10:12:20 +0000 (UTC)
Date:   Mon, 25 Oct 2021 11:12:20 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] ceph: add remote object copy counter to fs client
Message-ID: <YXaDBFvar4TS+EB8@suse.de>
References: <20211020143708.14728-1-lhenriques@suse.de>
 <34e379f9dec1cbdf09fffd8207f6ef7f4e1a6841.camel@kernel.org>
 <CA+2bHPbqeH_rmmxcnQ9gq0K8gqtE4q69a8cFnherSJCxSwXV5Q@mail.gmail.com>
 <99209198dd9d8634245f153a90e4091851635a16.camel@kernel.org>
 <CA+2bHPZTazVGtZygdbthQ-AWiC3AN_hsYouhVVs=PDo5iowgTw@mail.gmail.com>
 <e5627f7d9eb9cf2b753136e1187d5d6ff7789389.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e5627f7d9eb9cf2b753136e1187d5d6ff7789389.camel@kernel.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Oct 21, 2021 at 12:35:18PM -0400, Jeff Layton wrote:
> On Thu, 2021-10-21 at 12:18 -0400, Patrick Donnelly wrote:
> > On Thu, Oct 21, 2021 at 11:44 AM Jeff Layton <jlayton@kernel.org> wrote:
> > > 
> > > On Thu, 2021-10-21 at 09:52 -0400, Patrick Donnelly wrote:
> > > > On Wed, Oct 20, 2021 at 12:27 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > > 
> > > > > On Wed, 2021-10-20 at 15:37 +0100, Luís Henriques wrote:
> > > > > > This counter will keep track of the number of remote object copies done on
> > > > > > copy_file_range syscalls.  This counter will be filesystem per-client, and
> > > > > > can be accessed from the client debugfs directory.
> > > > > > 
> > > > > > Cc: Patrick Donnelly <pdonnell@redhat.com>
> > > > > > Signed-off-by: Luís Henriques <lhenriques@suse.de>
> > > > > > ---
> > > > > > This is an RFC to reply to Patrick's request in [0].  Note that I'm not
> > > > > > 100% sure about the usefulness of this patch, or if this is the best way
> > > > > > to provide the functionality Patrick requested.  Anyway, this is just to
> > > > > > get some feedback, hence the RFC.
> > > > > > 
> > > > > > Cheers,
> > > > > > --
> > > > > > Luís
> > > > > > 
> > > > > > [0] https://github.com/ceph/ceph/pull/42720
> > > > > > 
> > > > > 
> > > > > I think this would be better integrated into the stats infrastructure.
> > > > > 
> > > > > Maybe you could add a new set of "copy" stats to struct
> > > > > ceph_client_metric that tracks the total copy operations done, their
> > > > > size and latency (similar to read and write ops)?
> > > > 
> > > > I think it's a good idea to integrate this into "stats" but I think a
> > > > local debugfs file for some counters is still useful. The "stats"
> > > > module is immature at this time and I'd rather not build any qa tests
> > > > (yet) that rely on it.
> > > > 
> > > > Can we generalize this patch-set to a file named "op_counters" or
> > > > similar and additionally add other OSD ops performed by the kclient?
> > > > 
> > > 
> > > 
> > > Tracking this sort of thing is the main purpose of the stats code. I'm
> > > really not keen on adding a whole separate set of files for reporting
> > > this.
> > 
> > Maybe I'm confused. Is there some "file" which is already used for
> > this type of debugging information? Or do you mean the code for
> > sending stats to the MDS to support cephfs-top?
> > 
> > > What's the specific problem with relying on the data in debugfs
> > > "metrics" file?
> > 
> > Maybe no problem? I wasn't aware of a "metrics" file.
> > 
> 
> Yes. For instance:
> 
> # cat /sys/kernel/debug/ceph/*/metrics
> item                               total
> ------------------------------------------
> opened files  / total inodes       0 / 4
> pinned i_caps / total inodes       5 / 4
> opened inodes / total inodes       0 / 4
> 
> item          total       avg_lat(us)     min_lat(us)     max_lat(us)     stdev(us)
> -----------------------------------------------------------------------------------
> read          0           0               0               0               0
> write         5           914013          824797          1092343         103476
> metadata      79          12856           1572            114572          13262
> 
> item          total       avg_sz(bytes)   min_sz(bytes)   max_sz(bytes)  total_sz(bytes)
> ----------------------------------------------------------------------------------------
> read          0           0               0               0               0
> write         5           4194304         4194304         4194304         20971520
> 
> item          total           miss            hit
> -------------------------------------------------
> d_lease       11              0               29
> caps          5               68              10702
> 
> 
> I'm proposing that Luis add new lines for "copy" to go along with the
> "read" and "write" ones. The "total" counter should give you a count of
> the number of operations.

The problem with this is that it will require quite some work on the
MDS-side because, AFAIU, the MDS will need to handle different versions of
the CEPH_MSG_CLIENT_METRICS message (with and without the new copy-from
metrics).

Will this extra metric ever be useful on the MDS side?  From what I
understood Patrick's initial request was to have a way to find out, on the
client, if remote copies are really happening.  (*sigh* for not having
tracepoints.)

Anyway, I can look into adding this to the metrics infrastructure, but
it'll likely take me some more time to get to it and to figure out (once
again) how the messages versioning work.

Cheers,
--
Luís
