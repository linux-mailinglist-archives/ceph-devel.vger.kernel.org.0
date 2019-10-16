Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7636D9619
	for <lists+ceph-devel@lfdr.de>; Wed, 16 Oct 2019 17:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389795AbfJPP6j (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 16 Oct 2019 11:58:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:54506 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728018AbfJPP6i (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 16 Oct 2019 11:58:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7A1D9B41C;
        Wed, 16 Oct 2019 15:58:37 +0000 (UTC)
Date:   Wed, 16 Oct 2019 17:58:27 +0200
From:   Lars Marowsky-Bree <lmb@suse.com>
To:     dev@ceph.io, ceph-devel <ceph-devel@vger.kernel.org>
Subject: Re: local mode -- a new tier mode
Message-ID: <20191016155827.cwd4vrvul4aawyrq@suse.com>
References: <CAMrPN_JjckOAnQC_=C+YJ1+QTMRbUkGSu24Pyuo1EC=rfXGuRQ@mail.gmail.com>
 <CALZt5jz3F45NJZpPwAzcegtVcf6556z07MCTJx2Q0e4q8Jb5wg@mail.gmail.com>
 <CAMrPN_Jz2UaBCRuUUfb1-bwPEgvgEk7BJK4kTD35Tmt_ZBXK0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMrPN_Jz2UaBCRuUUfb1-bwPEgvgEk7BJK4kTD35Tmt_ZBXK0w@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
User-Agent: NeoMutt/20180716
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019-10-16T11:28:25, " Honggang(Joseph) Yang " <eagle.rtlinux@gmail.com> wrote:

I'm glad to see more performance work and caching happening in Ceph!

I admit calling this a "tier" (to get the bike shedding done first ;-)
is confusing me, because that used to mean something different. This
seems to me to be more of a BlueStore feature based on hints/access from
the upper layers?

So perhaps, at that level, it'd make sense to instead use the space on
the RocksDB partition/device for this caching operation, instead of yet
an additional device? (Intuitively, that's what most users already
expect it does, anyway.)

How would this, compared to bcache, possibly handle situations where
multiple OSDs share one caching device?

And does this only promote the local shard/replica? I'm wondering how
this would affect EC pools.


Regards,
    Lars

-- 
SUSE Linux GmbH, GF: Felix Imendörffer, Mary Higgins, Sri Rasiah, HRB 21284 (AG Nürnberg)
"Architects should open possibilities and not determine everything." (Ueli Zbinden)
