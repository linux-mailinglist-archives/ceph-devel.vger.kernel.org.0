Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F77E5401D7
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jun 2022 16:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343618AbiFGO5K (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Jun 2022 10:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343612AbiFGO5J (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Jun 2022 10:57:09 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225B1F5061;
        Tue,  7 Jun 2022 07:57:08 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C33CE1F916;
        Tue,  7 Jun 2022 14:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654613826; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A9Rvgtg9HKPFHzF0E5JqLvylQXRC6vGtm86k2c6/6jc=;
        b=ngoCSuRU2A1MoYFVMreHAKMfq4m77oscljFhyHWm2QRBonOEtbKJbvJOhroDtE5kPrsqV+
        ZiaszGagjzCYAvu2d6OL16pehyKlCOYIQHoXvQTWUJU2kBcYvAd22ws/plsGMEnHJjmWma
        q5WzDNOhimN/NFyJnYOClxNolJO69PQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654613826;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A9Rvgtg9HKPFHzF0E5JqLvylQXRC6vGtm86k2c6/6jc=;
        b=tYIJszqw8q1xnIw/PMezTR8KYg0Um/PLU2Agp+6ZMirstA+6ZE6Hs8ylBJ3sM5019PRCYE
        1oZP15OAvGgykpCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7C41B13A88;
        Tue,  7 Jun 2022 14:57:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ylY3G0Jnn2IjUwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 07 Jun 2022 14:57:06 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 004ad014;
        Tue, 7 Jun 2022 14:57:47 +0000 (UTC)
Date:   Tue, 7 Jun 2022 15:57:47 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: Re: [PATCH v2] ceph/001: skip metrics check if no copyfrom mount
 option is used
Message-ID: <Yp9na7/qSPxKuR5Y@suse.de>
References: <20220524094256.16746-1-lhenriques@suse.de>
 <20220524165926.dkighy46hi75mg6s@zlang-mailbox>
 <Yp9ho/m0m3Su8ZzA@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yp9ho/m0m3Su8ZzA@suse.de>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 07, 2022 at 03:33:07PM +0100, Luís Henriques wrote:
> On Wed, May 25, 2022 at 12:59:26AM +0800, Zorro Lang wrote:
> > On Tue, May 24, 2022 at 10:42:56AM +0100, Luís Henriques wrote:
> > > Checking the metrics is only valid if 'copyfrom' mount option is
> > > explicitly set, otherwise the kernel won't be doing any remote object
> > > copies.  Fix the logic to skip this metrics checking if 'copyfrom' isn't
> > > used.
> > > 
> > > Signed-off-by: Luís Henriques <lhenriques@suse.de>
> > > ---
> > >  tests/ceph/001 | 6 +++++-
> > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > > 
> > > Changes since v1:
> > > - Quoted 'hascopyfrom' variable in 'if' statement; while there, added
> > >   quotes to the 'if' statement just above.
> > 
> > Good to me,
> > Reviewed-by: Zorro Lang <zlang@redhat.com>
> 
> Ping.

Ok, please ignore my last two emails about 2 missing patches.  I was
looking at a local stale branch.  Sorry for the noise :-(
 
Cheers,
--
Luís

> 
> > > 
> > > diff --git a/tests/ceph/001 b/tests/ceph/001
> > > index 7970ce352bab..060c4c450091 100755
> > > --- a/tests/ceph/001
> > > +++ b/tests/ceph/001
> > > @@ -86,11 +86,15 @@ check_copyfrom_metrics()
> > >  	local copies=$4
> > >  	local c1=$(get_copyfrom_total_copies)
> > >  	local s1=$(get_copyfrom_total_size)
> > > +	local hascopyfrom=$(_fs_options $TEST_DEV | grep "copyfrom")
> > >  	local sum
> > >  
> > > -	if [ ! -d $metrics_dir ]; then
> > > +	if [ ! -d "$metrics_dir" ]; then
> > >  		return # skip metrics check if debugfs isn't mounted
> > >  	fi
> > > +	if [ -z "$hascopyfrom" ]; then
> > > +		return # ... or if we don't have copyfrom mount option
> > > +	fi
> > >  
> > >  	sum=$(($c0+$copies))
> > >  	if [ $sum -ne $c1 ]; then
> > > 
> > 
