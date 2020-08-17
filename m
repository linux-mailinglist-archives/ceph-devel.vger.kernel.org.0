Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804E8246832
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Aug 2020 16:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbgHQOPO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Aug 2020 10:15:14 -0400
Received: from smtprelay0032.hostedemail.com ([216.40.44.32]:39432 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728465AbgHQOPM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 17 Aug 2020 10:15:12 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id B25F118026136;
        Mon, 17 Aug 2020 14:15:10 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:967:968:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2560:2563:2682:2685:2736:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6117:8985:9025:10004:10400:10848:11232:11658:11914:12043:12297:12438:12679:12740:12760:12895:13019:13069:13071:13161:13229:13311:13357:13439:14180:14181:14659:14721:21060:21080:21433:21627:21811:21889:30054:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: able03_0f15ed127017
X-Filterd-Recvd-Size: 1732
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf03.hostedemail.com (Postfix) with ESMTPA;
        Mon, 17 Aug 2020 14:15:09 +0000 (UTC)
Message-ID: <0e130d4398b3e4a7e826a16b6726f0f0bce74900.camel@perches.com>
Subject: Re: [PATCH V2 6/6] ceph_debug: Remove now unused dout macro
 definitions
From:   Joe Perches <joe@perches.com>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date:   Mon, 17 Aug 2020 07:15:08 -0700
In-Reply-To: <CAOi1vP8rL6R8LqFnz10O=N4gfC2zYiZdfZbg3NkcePRvOKu7xA@mail.gmail.com>
References: <cover.1597626802.git.joe@perches.com>
         <fe4e9e2a544af4d00aa5c97d9288d9b4d67db1ed.1597626802.git.joe@perches.com>
         <CAOi1vP8rL6R8LqFnz10O=N4gfC2zYiZdfZbg3NkcePRvOKu7xA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-08-17 at 11:24 +0200, Ilya Dryomov wrote:
> On Mon, Aug 17, 2020 at 3:34 AM Joe Perches <joe@perches.com> wrote:
> > All the uses have be converted to pr_debug, so remove these.
[]
> Hi Joe,

Hi Ilya.

> Yeah, roughly the same thing can be achieved with +flmp instead
> of just +p with PRETTYDEBUG, but PRETTYDEBUG formatting actually
> predates those flags and some of us still use bash scripts from
> back then.  We also have a few guides and blog entries with just
> +p, but that's not a big deal.

btw: I sent a patch adding a +F flag to emit
the kbasename(FILE) to dynamic debug output.

https://lore.kernel.org/lkml/3e4a895e7c25e37c0f4727b960b7abdcf0752cbb.camel@perches.com/



