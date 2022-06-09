Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23CCA5446E5
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jun 2022 11:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233647AbiFIJIz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jun 2022 05:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbiFIJIy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Jun 2022 05:08:54 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA47E15A34;
        Thu,  9 Jun 2022 02:08:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 98A4021DC0;
        Thu,  9 Jun 2022 09:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654765731; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tur5UU7rDgKRCd+tfbHeLW85gSO5UusdM+hm2YCM11k=;
        b=nO3Ac60ug9vVLQBFH0j0aeY/W0kl4uClB9Q3JQNjNkXJXWWQwYG4gveZRDTBCatsG/XgYH
        6Ez0ooj6wU/T8VDTdwoBmIljrUHdDxNLVu0TJOBRnIKOc8nZFCNdjwKIwAWl1LWzN29pDB
        zzBk7+IDtpVkvgVlzJSGXwOHdAAvZGo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654765731;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tur5UU7rDgKRCd+tfbHeLW85gSO5UusdM+hm2YCM11k=;
        b=cSUbMQX3N7kIQ/ZzVQj2DkdR91gCw20p0y3LTBJtMSNmeQYFoaOnqi12u9pT5B3+2cqBHG
        EgjA93YK/a9OdWCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 383BD13456;
        Thu,  9 Jun 2022 09:08:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id zrLXCqO4oWLyYAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Thu, 09 Jun 2022 09:08:51 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 30e725ba;
        Thu, 9 Jun 2022 09:09:33 +0000 (UTC)
Date:   Thu, 9 Jun 2022 10:09:33 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     fstests@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] generic/020: adjust max_attrval_size for ceph
Message-ID: <YqG4zf2qD27nl4Vc@suse.de>
References: <20220607151513.26347-1-lhenriques@suse.de>
 <20220607151513.26347-2-lhenriques@suse.de>
 <20220608001642.GS1098723@dread.disaster.area>
 <YqBwAHhf8Bzk7VSa@suse.de>
 <20220608215341.GU1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220608215341.GU1098723@dread.disaster.area>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jun 09, 2022 at 07:53:41AM +1000, Dave Chinner wrote:
> On Wed, Jun 08, 2022 at 10:46:40AM +0100, Luís Henriques wrote:
> > On Wed, Jun 08, 2022 at 10:16:42AM +1000, Dave Chinner wrote:
> > > On Tue, Jun 07, 2022 at 04:15:12PM +0100, Luís Henriques wrote:
> > > > CephFS doesn't had a maximum xattr size.  Instead, it imposes a maximum
> > > > size for the full set of an inode's xattrs names+values, which by default
> > > > is 64K but it can be changed by a cluster admin.
> > > 
> > > So given the max attr name length is fixed by the kernel at 255
> > > bytes (XATTR_NAME_MAX), that means the max value length is somewhere
> > > around 65000 bytes, not 1024 bytes?
> > 
> > Right, but if the name is smaller (and in this test specifically we're not
> > using that XATTR_NAME_MAX), then that max value is > 65000.  Or if the
> > file already has some attributes set (which is the case in this test),
> > then this maximum will need to be adjusted accordingly.  (See below.)
> > 
> > > Really, we want to stress and exercise max supported sizes - if the
> > > admin reduces the max size on their test filesystems, that's not
> > > something we should be trying to work around in the test suite by
> > > preventing the test code from ever exercising attr values > 1024
> > > bytes.....
> > 
> > Agreed.  Xiubo also noted that and I also think this test shouldn't care
> > about other values.  I should drop (or at least rephrase) the reference to
> > different values in the commit text.
> > 
> > On Wed, Jun 08, 2022 at 04:41:25PM +0800, Xiubo Li wrote:
> > ...
> > > Why not fixing this by making sure that the total length of 'name' + 'value'
> > > == 64K instead for ceph case ?
> > 
> > The reason why I didn't do that is because the $testfile *already* has
> > another attribute set when we set this max value:
> > 
> > user.snrub="fish2\012"
> > 
> > which means that the maximum for this case will be:
> > 
> >  65536 - $max_attrval_namelen - strlen("user.snrub") - strlen("fish2\012")
> > 
> > I'll split the _attr_get_max() function in 2:
> > 
> >  * _attr_get_max() sets max_attrs which is needed in several places in
> >    generic/020
> >  * _attr_get_max_size() sets max_attrval_size, and gets called immediately
> >    before that value is needed so that it can take into account the
> >    current state.
> > 
> > Does this sound reasonable?
> 
> It seems like unnecessary additional complexity - keep it simple.
> Just set the max size for ceph to ~65000 and add a comment that says
> max name+val length for all ceph attrs is 64k and we need enough
> space of that space for two attr names...

OK, that sounds reasonable.  I'll send out v2 shortly.  Thanks.

Cheers,
--
Luís
