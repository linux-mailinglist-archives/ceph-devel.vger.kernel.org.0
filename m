Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70E77542C83
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Jun 2022 12:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235769AbiFHKEj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Jun 2022 06:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236085AbiFHKDD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Jun 2022 06:03:03 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2072116086A;
        Wed,  8 Jun 2022 02:46:00 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 225C521A90;
        Wed,  8 Jun 2022 09:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654681559; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HdoMl1wmeA1z5tZgcgv4CD2l0l8/poB3N0Xun3iep5U=;
        b=Ir6O61acHzTEI4Zr0wZ3u0AKY9Fht8uYs46vInz62wK7Bq/GzPyuk8ynligSpcI50cpFVm
        BWK6QgGngrksXfgFrOWT/v8UA2RUdsrFSd9f+nsEabIb2kcHAG1Vm1fN9U+EH7Ri/2Zcm/
        SuSVlob/MsfYzWR3zXFmDxDCo5tx7XM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654681559;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HdoMl1wmeA1z5tZgcgv4CD2l0l8/poB3N0Xun3iep5U=;
        b=bGu6N9N8dul+cDVFGr6VPRDyUKWYSc09gEZZ44KbaPTR4YhMdlXpzYrI5MIFI0YOK9PmKb
        27yfx3gJXlb+jIAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BC49D13A15;
        Wed,  8 Jun 2022 09:45:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id NPwSK9ZvoGI/awAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 08 Jun 2022 09:45:58 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id a3d14ed3;
        Wed, 8 Jun 2022 09:46:40 +0000 (UTC)
Date:   Wed, 8 Jun 2022 10:46:40 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Dave Chinner <david@fromorbit.com>
Cc:     fstests@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] generic/020: adjust max_attrval_size for ceph
Message-ID: <YqBwAHhf8Bzk7VSa@suse.de>
References: <20220607151513.26347-1-lhenriques@suse.de>
 <20220607151513.26347-2-lhenriques@suse.de>
 <20220608001642.GS1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220608001642.GS1098723@dread.disaster.area>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jun 08, 2022 at 10:16:42AM +1000, Dave Chinner wrote:
> On Tue, Jun 07, 2022 at 04:15:12PM +0100, Luís Henriques wrote:
> > CephFS doesn't had a maximum xattr size.  Instead, it imposes a maximum
> > size for the full set of an inode's xattrs names+values, which by default
> > is 64K but it can be changed by a cluster admin.
> 
> So given the max attr name length is fixed by the kernel at 255
> bytes (XATTR_NAME_MAX), that means the max value length is somewhere
> around 65000 bytes, not 1024 bytes?

Right, but if the name is smaller (and in this test specifically we're not
using that XATTR_NAME_MAX), then that max value is > 65000.  Or if the
file already has some attributes set (which is the case in this test),
then this maximum will need to be adjusted accordingly.  (See below.)

> Really, we want to stress and exercise max supported sizes - if the
> admin reduces the max size on their test filesystems, that's not
> something we should be trying to work around in the test suite by
> preventing the test code from ever exercising attr values > 1024
> bytes.....

Agreed.  Xiubo also noted that and I also think this test shouldn't care
about other values.  I should drop (or at least rephrase) the reference to
different values in the commit text.

On Wed, Jun 08, 2022 at 04:41:25PM +0800, Xiubo Li wrote:
...
> Why not fixing this by making sure that the total length of 'name' + 'value'
> == 64K instead for ceph case ?

The reason why I didn't do that is because the $testfile *already* has
another attribute set when we set this max value:

user.snrub="fish2\012"

which means that the maximum for this case will be:

 65536 - $max_attrval_namelen - strlen("user.snrub") - strlen("fish2\012")

I'll split the _attr_get_max() function in 2:

 * _attr_get_max() sets max_attrs which is needed in several places in
   generic/020
 * _attr_get_max_size() sets max_attrval_size, and gets called immediately
   before that value is needed so that it can take into account the
   current state.

Does this sound reasonable?

Cheers,
--
Luís
