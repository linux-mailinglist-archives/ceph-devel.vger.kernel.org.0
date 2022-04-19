Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14393506DD9
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Apr 2022 15:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352679AbiDSNnu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Apr 2022 09:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352745AbiDSNmm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 19 Apr 2022 09:42:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877DDF07
        for <ceph-devel@vger.kernel.org>; Tue, 19 Apr 2022 06:39:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02504B8197D
        for <ceph-devel@vger.kernel.org>; Tue, 19 Apr 2022 13:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4477DC385A8;
        Tue, 19 Apr 2022 13:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650375589;
        bh=KMjMMexd9z46MFplwUfeLmUcvKLrSVpvExotqI0L0fQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=s2089beKVkSu6osAu/LfT99zmZqzapw1e1YbYHPMGRAy2lvvsl3nI7rv2hiQrpaq9
         p961SFZRX+oQYG62M7ItbTRB0TGekcLPsz1JTfxswRHquzBLbZrEY88eIIou1F7nno
         DQgXPfgD4b7avfOXlILCnRssfz/Xbq02q5z7B2jqqwSC5fH3Q/h3y0wBtkN4vTe+Bq
         SgfDofGHmYK3FguwwrIUBgOQqrpl1jRvSIQHaXB3kvZGu1y2TKBfuzhvK17JIxMZUd
         ksR0kZjQMuxKRMVcjvedrc+o4N1dtgBVVB2IKEZegLy+V3y2ThY82wqUk8QmTng9hj
         XdTmjTQlwUDrA==
Message-ID: <610f7e73c1ed78a5915bddac0fb5f77de6acccf3.camel@kernel.org>
Subject: Re: [RFC resend PATCH] ceph: fix statx AT_STATX_DONT_SYNC vs
 AT_STATX_FORCE_SYNC check
From:   Jeff Layton <jlayton@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     Xiubo Li <xiubli@redhat.com>, idryomov@gmail.com,
        vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 19 Apr 2022 09:39:47 -0400
In-Reply-To: <459212.1650375050@warthog.procyon.org.uk>
References: <d873b14bc110c98f8c62cfabafc30a7d942e3064.camel@kernel.org>
         <54d0b7f67cc1c8302fc2d4ff6109d0090f6a4220.camel@kernel.org>
         <20220411093405.301667-1-xiubli@redhat.com>
         <c013aafd233d4ec303238425b11f6c96c8a3b7a7.camel@kernel.org>
         <b38b37bc-faa7-cbae-ce3a-f10c0818a293@redhat.com>
         <d57a0fd93e18d065a0deb3c82dc43595e67b2326.camel@kernel.org>
         <d81b7216-2694-4ec2-17b4-0869f485f757@redhat.com>
         <458688.1650374525@warthog.procyon.org.uk>
         <459212.1650375050@warthog.procyon.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-04-19 at 14:30 +0100, David Howells wrote:
> Jeff Layton <jlayton@kernel.org> wrote:
> 
> > On Tue, 2022-04-19 at 14:22 +0100, David Howells wrote:
> > > Jeff Layton <jlayton@kernel.org> wrote:
> > > 
> > > >     if ((flags & AT_STATX_SYNC_TYPE) == (AT_STATX_DONT_SYNC|AT_STATX_FORCE_SYNC))
> > > 
> > > You can't do that.  DONT_SYNC and FORCE_SYNC aren't bit flags - they're an
> > > enumeration in a bit field.  There's a reserved value at 0x6000 that doesn't
> > > have a symbol assigned.
> > > 
> > 
> > Right, but nothing prevents you from setting both flags at the same
> > time. How should we interpret such a request?
> 
> A good question without a necessarily right answer.
> 
> Possibly we should do:
> 
>  #define AT_STATX_SYNC_TYPE	0x6000	/* Type of synchronisation required from statx() */
>  #define AT_STATX_SYNC_AS_STAT	0x0000	/* - Do whatever stat() does */
>  #define AT_STATX_FORCE_SYNC	0x2000	/* - Force the attributes to be sync'd with the server */
>  #define AT_STATX_DONT_SYNC	0x4000	/* - Don't sync attributes with the server */
> +#define AT_STATX_SYNC_RESERVED	0x6000
> 
> and give EINVAL if we see the reserved value.  But also these values can be
> considered a hint, so possibly we should just ignore the reserved value.  Oh
> for fsinfo()...
> 
> David
> 

That was what the code (pre-patch) did. If someone set
DONT_SYNC|FORCE_SYNC, it would just ignore FORCE_SYNC. It's not ideal,
but I suppose we're within our rights to prefer either behaviour in that
case if someone sets both flags.

In hindsight, setting both should have probably caused the syscall to
throw back -EINVAL, but changing that now is probably a bit dangerous.
-- 
Jeff Layton <jlayton@kernel.org>
