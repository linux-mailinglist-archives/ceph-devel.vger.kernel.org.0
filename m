Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5478540173
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jun 2022 16:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244447AbiFGOcb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Jun 2022 10:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiFGOc3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Jun 2022 10:32:29 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F32A57B21;
        Tue,  7 Jun 2022 07:32:27 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6289921991;
        Tue,  7 Jun 2022 14:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654612346; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I4emLTCIsOQsiQS0phw/LVM6r2iPjLA2WL2vfK3Okgc=;
        b=E9TxjCFBZdV2BVBIF6D95zFm9Zb/Da+937+F6ZEbdVCC6GzIWCiLyQNHFUrCFQcjIWBtBy
        HKcsvJp5D9CX7mYLAM7LOkpPt9GP5/r/Mdh+uxWK0pe/gxRgIAHiRW2SzGwsxQsTs0ezXR
        sBaG20HeCcsLucuiRfOl0HGVsT9U8a0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654612346;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I4emLTCIsOQsiQS0phw/LVM6r2iPjLA2WL2vfK3Okgc=;
        b=EsZNWx+JME1QsiG9JX1SSyEN50NZPIPren46ppPh3CDgA+oPdu+5e5DJskZiLf7EFQ9aso
        QRp4ElJIrR2Y8eCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1C6B913638;
        Tue,  7 Jun 2022 14:32:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /NGOA3phn2L+RwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 07 Jun 2022 14:32:26 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id fff50aa0;
        Tue, 7 Jun 2022 14:33:07 +0000 (UTC)
Date:   Tue, 7 Jun 2022 15:33:07 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: Re: [PATCH v2] ceph/001: skip metrics check if no copyfrom mount
 option is used
Message-ID: <Yp9ho/m0m3Su8ZzA@suse.de>
References: <20220524094256.16746-1-lhenriques@suse.de>
 <20220524165926.dkighy46hi75mg6s@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220524165926.dkighy46hi75mg6s@zlang-mailbox>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, May 25, 2022 at 12:59:26AM +0800, Zorro Lang wrote:
> On Tue, May 24, 2022 at 10:42:56AM +0100, Luís Henriques wrote:
> > Checking the metrics is only valid if 'copyfrom' mount option is
> > explicitly set, otherwise the kernel won't be doing any remote object
> > copies.  Fix the logic to skip this metrics checking if 'copyfrom' isn't
> > used.
> > 
> > Signed-off-by: Luís Henriques <lhenriques@suse.de>
> > ---
> >  tests/ceph/001 | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > Changes since v1:
> > - Quoted 'hascopyfrom' variable in 'if' statement; while there, added
> >   quotes to the 'if' statement just above.
> 
> Good to me,
> Reviewed-by: Zorro Lang <zlang@redhat.com>

Ping.

Cheers,
--
Luís


> > 
> > diff --git a/tests/ceph/001 b/tests/ceph/001
> > index 7970ce352bab..060c4c450091 100755
> > --- a/tests/ceph/001
> > +++ b/tests/ceph/001
> > @@ -86,11 +86,15 @@ check_copyfrom_metrics()
> >  	local copies=$4
> >  	local c1=$(get_copyfrom_total_copies)
> >  	local s1=$(get_copyfrom_total_size)
> > +	local hascopyfrom=$(_fs_options $TEST_DEV | grep "copyfrom")
> >  	local sum
> >  
> > -	if [ ! -d $metrics_dir ]; then
> > +	if [ ! -d "$metrics_dir" ]; then
> >  		return # skip metrics check if debugfs isn't mounted
> >  	fi
> > +	if [ -z "$hascopyfrom" ]; then
> > +		return # ... or if we don't have copyfrom mount option
> > +	fi
> >  
> >  	sum=$(($c0+$copies))
> >  	if [ $sum -ne $c1 ]; then
> > 
> 
