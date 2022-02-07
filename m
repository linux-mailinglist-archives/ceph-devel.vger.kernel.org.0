Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8917C4AC72F
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Feb 2022 18:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237499AbiBGRW5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Feb 2022 12:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392027AbiBGRMH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Feb 2022 12:12:07 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853D2C03E943
        for <ceph-devel@vger.kernel.org>; Mon,  7 Feb 2022 09:11:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2FC01CE1178
        for <ceph-devel@vger.kernel.org>; Mon,  7 Feb 2022 17:11:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B214DC004E1;
        Mon,  7 Feb 2022 17:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644253883;
        bh=ShwbwQx7EGnF5L1MMNLYgeDejhdQ9LxlxtAKzAwAx24=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ey2/tpPjcUZ3cSThilNwh19k81NR+UMP3Ueq/EXGyajZHFK8NcP2nN090GG5TvFCg
         rcGMwpTCHIRLSE4GGVAbq5UHOB9lCr7rCWqBgsp4dzr3bdyGd6jv19ngJROO8rSj0w
         soT14gJ4uZc4iS2OpGID0uSlRf5SqMguNglsYPcPLZSKLx0fy5D0c34KP0Rzif88mI
         TmzL1lzooC7hTxGNu2Tmfx7z9Y30NETG/i5yOThHXNGbN95LfeFS57mXN8LxWR0sKV
         nRMcvWq8wFzTDsn5Tf0k/Fj8C5e4hpCl964i5EE6Uq8RXxeTrN/nBRTxD9bVxeKFT9
         5cDXbz53TOjiw==
Message-ID: <9ee4afece5bc3445ed19a3344a11eeab697ff37e.camel@kernel.org>
Subject: Re: [PATCH] ceph: fail the request directly if handle_reply gets an
 ESTALE
From:   Jeff Layton <jlayton@kernel.org>
To:     Gregory Farnum <gfarnum@redhat.com>
Cc:     Dan van der Ster <dan@vanderster.com>,
        Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Sage Weil <sage@newdream.net>, ukernel <ukernel@gmail.com>
Date:   Mon, 07 Feb 2022 12:11:21 -0500
In-Reply-To: <CAJ4mKGb3j_QNMuKmccoj43jswoReb_iP8wnJi3f-mpaN++PC7w@mail.gmail.com>
References: <20220207050340.872893-1-xiubli@redhat.com>
         <77bd8ec8fb97107deb57c641b5e471b8eeb828c8.camel@kernel.org>
         <CAJ4mKGbHyn-oQwL8D3Ove0d2tD++VEXOTMSj5EDbcBk3SFX=2w@mail.gmail.com>
         <d6f16704da303eca4d62aee58eecacb45f76f45a.camel@kernel.org>
         <CAJ4mKGb3j_QNMuKmccoj43jswoReb_iP8wnJi3f-mpaN++PC7w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2022-02-07 at 08:28 -0800, Gregory Farnum wrote:
> On Mon, Feb 7, 2022 at 8:13 AM Jeff Layton <jlayton@kernel.org> wrote:
> > The tracker bug mentions that this occurs after an MDS is restarted.
> > Could this be the result of clients relying on delete-on-last-close
> > behavior?
> 
> Oooh, I didn't actually look at the tracker.
> 
> > 
> > IOW, we have a situation where a file is opened and then unlinked, and
> > userland is actively doing I/O to it. The thing gets moved into the
> > strays dir, but isn't unlinked yet because we have open files against
> > it. Everything works fine at this point...
> > 
> > Then, the MDS restarts and the inode gets purged altogether. Client
> > reconnects and tries to reclaim his open, and gets ESTALE.
> 
> Uh, okay. So I didn't do a proper audit before I sent my previous
> reply, but one of the cases I did see was that the MDS returns ESTALE
> if you try to do a name lookup on an inode in the stray directory. I
> don't know if that's what is happening here or not? But perhaps that's
> the root of the problem in this case.
> 
> Oh, nope, I see it's issuing getattr requests. That doesn't do ESTALE
> directly so it must indeed be coming out of MDCache::path_traverse.
> 
> The MDS shouldn't move an inode into the purge queue on restart unless
> there were no clients with caps on it (that state is persisted to disk
> so it knows). Maybe if the clients don't make the reconnect window
> it's dropping them all and *then* moves it into purge queue? I think
> we need to identify what's happening there before we issue kernel
> client changes, Xiubo?


Agreed. I think we need to understand why he's seeing ESTALE errors in
the first place, but it sounds like retrying on an ESTALE error isn't
likely to be helpful.
-- 
Jeff Layton <jlayton@kernel.org>
