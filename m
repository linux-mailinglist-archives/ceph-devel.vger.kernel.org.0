Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9314CA9F2
	for <lists+ceph-devel@lfdr.de>; Wed,  2 Mar 2022 17:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241428AbiCBQQd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 2 Mar 2022 11:16:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239124AbiCBQQc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 2 Mar 2022 11:16:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8894BCD303
        for <ceph-devel@vger.kernel.org>; Wed,  2 Mar 2022 08:15:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 260B46179F
        for <ceph-devel@vger.kernel.org>; Wed,  2 Mar 2022 16:15:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2139BC004E1;
        Wed,  2 Mar 2022 16:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646237748;
        bh=Y3D0Yyt0StQaM6kJAE08xRV+AMFOykPLVRZWy8f4YH8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hqJQVOGIunQT4EN7EYtdpY1qKSQpixR5ytMSBHs8ASJkZyvakTeFt6EVZYruyytqv
         L+gmXLARmDGl7bP35UgWr3zTj2G3PMp8T2m6aZgCL6NxCDTEBs6rjJn9Yet/P+Pe2d
         AA4237Ko7tl3YjePSXo3nrZUK4/QbCyGeN1mGOtFP/BRHSlAfEH5b5pv5sdzicfbXt
         Jri9g08XqZ2hptToqorv4HdK5jLkoBR6qhpMJ6sS2l604jJsu8aX7UNTsX7jwwt/XB
         xWNHQmPPIGNqPKCeUdH7yADAh/94dm3acJi5I6di6+Fp78P8gLVNbPDhsXAuwcDMRZ
         BDFs3L2amIkEg==
Message-ID: <a2fef081f2fd7b65990d56b99292880e4ac0b842.camel@kernel.org>
Subject: Re: [PATCH] libceph: fix last_piece calculation in
 ceph_msg_data_pages_advance
From:   Jeff Layton <jlayton@kernel.org>
To:     Alex Elder <elder@ieee.org>, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, xiubli@redhat.com
Date:   Wed, 02 Mar 2022 11:15:46 -0500
In-Reply-To: <b10682fe-54a9-5103-4921-66f8c0f22382@ieee.org>
References: <20220302153744.43541-1-jlayton@kernel.org>
         <b10682fe-54a9-5103-4921-66f8c0f22382@ieee.org>
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

On Wed, 2022-03-02 at 09:41 -0600, Alex Elder wrote:
> On 3/2/22 9:37 AM, Jeff Layton wrote:
> > It's possible we'll have less than a page's worth of residual data, that
> > is stradding the last two pages in the array. That will make it
> > incorrectly set the last_piece boolean when it shouldn't.
> > 
> > Account for a non-zero cursor->page_offset when advancing.
> 
> It's been quite a while I looked at this code, but isn't
> cursor->resid supposed to be the number of bytes remaining,
> irrespective of the offset?
> 

Correct. The "residual" bytes in the cursor, AFAICT.

> Have you found this to cause a failure?
> 

Not with the existing code in libceph, as it only ever seems to advance
to the end of the page. I'm working on some patches to allow for sparse
reads though, and with those in place I need to sometimes advance to
arbitrary positions in the array, and this reliably causes a BUG_ON() to
trip.



> 					-Alex
> 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >   net/ceph/messenger.c | 3 +--
> >   1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> > index d3bb656308b4..3f8453773cc8 100644
> > --- a/net/ceph/messenger.c
> > +++ b/net/ceph/messenger.c
> > @@ -894,10 +894,9 @@ static bool ceph_msg_data_pages_advance(struct ceph_msg_data_cursor *cursor,
> >   		return false;   /* no more data */
> >   
> >   	/* Move on to the next page; offset is already at 0 */
> > -
> >   	BUG_ON(cursor->page_index >= cursor->page_count);
> >   	cursor->page_index++;
> > -	cursor->last_piece = cursor->resid <= PAGE_SIZE;
> > +	cursor->last_piece = cursor->page_offset + cursor->resid <= PAGE_SIZE;
> >   
> >   	return true;
> >   }
> 

-- 
Jeff Layton <jlayton@kernel.org>
