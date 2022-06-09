Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 110A25448EC
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jun 2022 12:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbiFIKbu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jun 2022 06:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233862AbiFIKbt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Jun 2022 06:31:49 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4411220EE96;
        Thu,  9 Jun 2022 03:31:48 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 03B3421E10;
        Thu,  9 Jun 2022 10:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654770707; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5I3kwWcGF0sqQZ0z5uVggswDypPeJhM7ZrZj3hd+LuM=;
        b=J+lNWprMqaVvOo4qdBkM+rsyO8pZRIzH5/O8gextgyxs2+zgc56O9kOvSckmp45i2ks/7B
        gV/oUe9wBMqqbBsd9f2xVSAyB9/GI3bOonQHhFY4qAanLQ6qIPGIu7E9POfX3xl36qReYe
        1yPLc/pyRAtbu8QmrkAT5tiwexJevu0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654770707;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5I3kwWcGF0sqQZ0z5uVggswDypPeJhM7ZrZj3hd+LuM=;
        b=728j16rk7HcpisXxo5EfqPdVq0i9pNfcbmXXLgkfYoWgFp25immNhPeFwV4aaYLvLe7kJu
        bxtdtsShUarTZ0DQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9437113A8C;
        Thu,  9 Jun 2022 10:31:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 5TExIRLMoWJgBwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Thu, 09 Jun 2022 10:31:46 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id f9d9d251;
        Thu, 9 Jun 2022 10:32:28 +0000 (UTC)
Date:   Thu, 9 Jun 2022 11:32:28 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     fstests@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] src/attr_replace_test: dynamically adjust the max
 xattr size
Message-ID: <YqHMPEZemvpuMAut@suse.de>
References: <20220607151513.26347-1-lhenriques@suse.de>
 <20220607151513.26347-3-lhenriques@suse.de>
 <20220608002315.GT1098723@dread.disaster.area>
 <YqByggmCzXGAosM+@suse.de>
 <20220608215950.GV1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220608215950.GV1098723@dread.disaster.area>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jun 09, 2022 at 07:59:50AM +1000, Dave Chinner wrote:
> On Wed, Jun 08, 2022 at 10:57:22AM +0100, Luís Henriques wrote:
> > On Wed, Jun 08, 2022 at 10:23:15AM +1000, Dave Chinner wrote:
> > > On Tue, Jun 07, 2022 at 04:15:13PM +0100, Luís Henriques wrote:
> > > > CephFS doesn't had a maximum xattr size.  Instead, it imposes a maximum
> > > > size for the full set of an inode's xattrs names+values, which by default
> > > > is 64K but it can be changed by a cluster admin.
> > > > 
> > > > Test generic/486 started to fail after fixing a ceph bug where this limit
> > > > wasn't being imposed.  Adjust dynamically the size of the xattr being set
> > > > if the error returned is -ENOSPC.
> > > 
> > > Ah, this shouldn't be getting anywhere near the 64kB limit unless
> > > ceph is telling userspace it's block size is > 64kB:
> > > 
> > > size = sbuf.st_blksize * 3 / 4;
> > > .....
> > > size = MIN(size, XATTR_SIZE_MAX);
> > 
> > Yep, that's exactly what is happening.  The cephfs kernel client reports
> > here the value that is being used for ceph "object size", which defaults
> > to 4M.  Hence, we'll set size to XATTR_SIZE_MAX.
> 
> Yikes. This is known to break random applications that size buffers
> based on a multiple of sbuf.st_blksize and assume that it is going
> to be roughly 4kB. e.g. size a buffer at 1024 * sbuf.st_blksize,
> expecting to get a ~4MB buffer, and instead it tries to allocate
> a 4GB buffer....
> 
> > > Regardless, the correct thing to do here is pass the max supported
> > > xattr size from the command line (because fstests knows what that it
> > > for each filesystem type) rather than hard coding
> > > XATTR_SIZE_MAX in the test.
> > 
> > OK, makes sense.  But then, for the ceph case, it becomes messy because we
> > also need to know the attribute name to compute the maximum size.  I guess
> > we'll need an extra argument for that too.
> 
> Just pass in a size for ceph that has enough spare space for the
> attribute names in it, like for g/020. Don't make it more
> complex than it needs to be.

Well, in that case it's just easier for attr_replace_test.c to simply set
the ceiling to (XATTR_SIZE_MAX - strlen(name+value)).  This is because the
fstests don't really know anymore the max xattr size for each filesystem
type; that knowledge is local to generic/020.  The other option is to move
that code (back) to common/attr.

Cheers,
--
Luís
