Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB89224E51
	for <lists+ceph-devel@lfdr.de>; Sun, 19 Jul 2020 02:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgGSARm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 18 Jul 2020 20:17:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726209AbgGSARm (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Sat, 18 Jul 2020 20:17:42 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5F662070A;
        Sun, 19 Jul 2020 00:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595117862;
        bh=WAIK+1JsqmY8MPZ046Zu5M29nj3lVBnJ9BsdAywmavc=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=2Xo1CX4DRfBLUANwEMsQKUi7kObBCLQRzwJBT6kMW8hBIG5imOQdPV6/tP0ZGXbVv
         RriBeTmUDWUfuwq29f6F+gF+PEq2+9fy3UU7FhJBCbYVyBgs6hfeWUwJ1Hc6a//DC7
         hV5uWBgs6JIjGKQXnj2ggFUqhUN8d5SELZQH446g=
Message-ID: <4706f02713a0c8c46a7892a275ab2ae01cdb6b7b.camel@kernel.org>
Subject: Re: Crimson & Seastore
From:   Jeff Layton <jlayton@kernel.org>
To:     "Rob Tilley Jr." <rftilleyjr@gmail.com>, ceph-devel@vger.kernel.org
Date:   Sat, 18 Jul 2020 20:17:40 -0400
In-Reply-To: <CAEDtz9YeQOACR9rDERK7kBsb1j0e80SB1k_p+LAAjKMyxez==A@mail.gmail.com>
References: <CAEDtz9YeQOACR9rDERK7kBsb1j0e80SB1k_p+LAAjKMyxez==A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, 2020-07-18 at 19:46 -0400, Rob Tilley Jr. wrote:
> All,
> 
> I am really looking forward to using Crimson with Seastore. Do you
> have any ideas on when this will become "stable" enough to use in a
> production environment? Even if it is in beta, I'd like to implement
> it in a production environment if it's stable, if future releases will
> allow for in-place upgrade. Any information on this would be greatly
> appreciated.
> 
> 

Hi Rob,

This list is mainly for info about the Linux kernel clients now. You
should probably send this to one of the other ceph lists (maybe 
dev@ceph.io, for this question). See:

    https://ceph.io/irc/

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

