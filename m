Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91C5456D86
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jun 2019 17:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbfFZPVW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Jun 2019 11:21:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:39156 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727139AbfFZPVW (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 11:21:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E0800AE78;
        Wed, 26 Jun 2019 15:21:20 +0000 (UTC)
Date:   Wed, 26 Jun 2019 17:21:15 +0200
From:   Lars Marowsky-Bree <lmb@suse.com>
To:     Ceph Devel <ceph-devel@vger.kernel.org>,
        Ceph-User <ceph-users@ceph.com>, dev@ceph.io
Subject: Re: [ceph-users] Changing the release cadence
Message-ID: <20190626152115.wpov73iazdhoy3rd@suse.com>
References: <alpine.DEB.2.11.1906051556500.987@piezo.novalocal>
 <alpine.DEB.2.11.1906171621000.20504@piezo.novalocal>
 <CAN-Gep+9bxadHMTFQgUFUt_q9Jmfpy3MPU5UTTRNY1jueu7n9w@mail.gmail.com>
 <CAC-Np1zcniBxm84SEGhzYfu55t+fckg1d-Dq0xpab62+ON4K5w@mail.gmail.com>
 <CAE6AcseMEfRjRtA0iUPMwsQPP+ebEqDDHYeWUpXWGeWTggnKRw@mail.gmail.com>
 <alpine.DEB.2.11.1906261255530.17148@piezo.novalocal>
 <alpine.DEB.2.11.1906261437280.17148@piezo.novalocal>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.11.1906261437280.17148@piezo.novalocal>
X-Clacks-Overhead: GNU Terry Pratchett
User-Agent: NeoMutt/20180716
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019-06-26T14:45:31, Sage Weil <sweil@redhat.com> wrote:

Hi Sage,

I think that makes sense. I'd have preferred the Oct/Nov target, but
that'd have made Octopus quite short.

Unsure whether freezing in December with a release in March is too long
though. But given how much people scramble, setting that as a goal
probably will help with stabilization.

I'm also hoping that one day, we can move towards a more agile
continuously integration model (like the Linux kernel does) instead of
massive yearly forklifts. But hey, that's just me ;-)



Regards,
    Lars

-- 
SUSE Linux GmbH, GF: Felix Imendörffer, Mary Higgins, Sri Rasiah, HRB 21284 (AG Nürnberg)
"Architects should open possibilities and not determine everything." (Ueli Zbinden)
