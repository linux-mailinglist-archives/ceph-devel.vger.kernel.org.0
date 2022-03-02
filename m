Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3D714CAD42
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Mar 2022 19:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244682AbiCBSOl (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Mar 2022 13:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241610AbiCBSOd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Mar 2022 13:14:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5639FB5626
        for <ceph-devel@vger.kernel.org>; Wed,  2 Mar 2022 10:13:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B275B82108
        for <ceph-devel@vger.kernel.org>; Wed,  2 Mar 2022 18:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9FBC004E1;
        Wed,  2 Mar 2022 18:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646244777;
        bh=BHHWlG527xqttAQj7HWVVdrn+tqnuNkfweu5GAqR16U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ivfupqx5yC/jOGPCm9ZgWxzbaeapDY6xaVIzf9HYw6AVTJIR761LktaoKq2hldeFc
         QM/QG6RvkRs7jXtAez6DCvGxX48t8U/YHlkF3yiV0OVSalX23uMD4ufnhOHxXYYO5H
         Y/3uksqiypJgL59KjVIXNhc39SqbdpGZKut7xTOogmLiv91BO3yYyqBEiMSFLgqoxv
         akKearEABm3apncq4px9n3TAmIcnHQaaKNF3jByBs0yAtsxhan08UFgSDxtJ1zvN+D
         5fAcvzgSfJ75fNRl0B0G/nOAiEgujXEL7oqGh+3LeTSLt+XMh4V+OIrhFttinKMZIZ
         rMS49T7cF1rxA==
Message-ID: <8faef6d2b8f7681e229b5951013f524f6f11cc42.camel@kernel.org>
Subject: Re: [PATCH] libceph: fix last_piece calculation in
 ceph_msg_data_pages_advance
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Alex Elder <elder@ieee.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Xiubo Li <xiubli@redhat.com>
Date:   Wed, 02 Mar 2022 13:12:55 -0500
In-Reply-To: <CAOi1vP_dbPNBwsLDe3uFHL0j1WDKdtEQxg9yDDBPwYM-CuOKog@mail.gmail.com>
References: <20220302153744.43541-1-jlayton@kernel.org>
         <b10682fe-54a9-5103-4921-66f8c0f22382@ieee.org>
         <a2fef081f2fd7b65990d56b99292880e4ac0b842.camel@kernel.org>
         <CAOi1vP_dbPNBwsLDe3uFHL0j1WDKdtEQxg9yDDBPwYM-CuOKog@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2022-03-02 at 18:03 +0100, Ilya Dryomov wrote:
> On Wed, Mar 2, 2022 at 5:15 PM Jeff Layton <jlayton@kernel.org> wrote:
> > 
> > On Wed, 2022-03-02 at 09:41 -0600, Alex Elder wrote:
> > > On 3/2/22 9:37 AM, Jeff Layton wrote:
> > > > It's possible we'll have less than a page's worth of residual data, that
> > > > is stradding the last two pages in the array. That will make it
> > > > incorrectly set the last_piece boolean when it shouldn't.
> > > > 
> > > > Account for a non-zero cursor->page_offset when advancing.
> > > 
> > > It's been quite a while I looked at this code, but isn't
> > > cursor->resid supposed to be the number of bytes remaining,
> > > irrespective of the offset?
> > > 
> > 
> > Correct. The "residual" bytes in the cursor, AFAICT.
> > 
> > > Have you found this to cause a failure?
> > > 
> > 
> > Not with the existing code in libceph, as it only ever seems to advance
> > to the end of the page. I'm working on some patches to allow for sparse
> > reads though, and with those in place I need to sometimes advance to
> > arbitrary positions in the array, and this reliably causes a BUG_ON() to
> > trip.
> 
> Hi Jeff,
> 
> Which BUG_ON?  Can you explain what "advance to arbitrary positions in
> the array" means?
> 
> I think you may be misusing ceph_msg_data_pages_advance() because
> cursor->page_offset _has_ to be zero at that point: we have just
> determined that we are done with the current page and incremented
> cursor->page_index (i.e. moved to the next page).  The way we
> determine whether we are done with the current page is by testing
> cursor->page_offset == 0, so either your change is a no-op or
> something else is broken.
> 

My apologies, I've got a stack of other patches sitting on top of this,
and this patch should have been folded into one of them instead of being
sent separately.

In the sparse_read code I have now, I'm creating some temporary
ceph_msg_data_cursors on the stack and revamped the "advance" code to
allow advancing an arbirtrary amount instead of only allowing it to go
to the end of the current page. This fix is necessary with those
changes.

I'm not sure I'm going to need that going forward though, as I may
rework the patches (again) to use the cursor in the con, and in that
case I'll only need to walk through it a page at a time like we do now.

We can drop this patch.
--
Jeff Layton <jlayton@kernel.org>
