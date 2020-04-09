Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44CDA1A380C
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Apr 2020 18:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgDIQaH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Apr 2020 12:30:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbgDIQaH (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 9 Apr 2020 12:30:07 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DB3420768;
        Thu,  9 Apr 2020 16:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586449807;
        bh=np9mi0pCMA6aepzW3JgI3wBSFe5jiHMWl79SxMX8iI4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=K5+3LoDrAKjzNC4B5PrLS1svVYms8Ig2Onh+siO8Ka1fcwTBTABfdiMd/k4McaqKO
         uVYonzQm5PkXor7t3o05fDL0U941yJD6F/UxhWW5pgUd+DRhv8mawlEWbcG04SMKMK
         zCHAXjr2g6Lt2GFaQzulBH5ZVCYxxI1+Jjvn0TqQ=
Message-ID: <25bc975e164a73f18653156d6591dda785c8d0c1.camel@kernel.org>
Subject: Re: 5.4.20 - high load - lots of incoming data - small data read.
From:   Jeff Layton <jlayton@kernel.org>
To:     Jesper Krogh <jesper.krogh@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Date:   Thu, 09 Apr 2020 12:30:05 -0400
In-Reply-To: <CAED-sic=eDaXz-A6_ejZOYcJYs=-tJtmxXLcONdQRRCod59L_g@mail.gmail.com>
References: <CAED-sidS3jt5f0nTvLp6_xL+sgk0FFJGaX-X7cCDav-8nwj4TA@mail.gmail.com>
         <db72c749125519b9c042c9664918eacbe8744985.camel@kernel.org>
         <CAED-sie+qsrr3yZVAiB=t6cAzWUwX9Y=32srJY2dwyRpSXvgxg@mail.gmail.com>
         <e9c9ffb60265aebdab6edd7ce1565402eb787270.camel@kernel.org>
         <CAED-sicefQuJ3GGWh2bBXz6R=BFr1EQ=h6Sz-W_mh3u+-tO0wA@mail.gmail.com>
         <cbbc31d2041601b3e0d2c9b1e8b657ffa23ed97e.camel@kernel.org>
         <CAED-sic=eDaXz-A6_ejZOYcJYs=-tJtmxXLcONdQRRCod59L_g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-04-09 at 18:00 +0200, Jesper Krogh wrote:
> Thanks Jeff - I'll try that.
> 
> I would just add to the case that this is a problem we have had on a
> physical machine - but too many "other" workloads at the same time -
> so we isolated it off to a VM - assuming that it was the mixed
> workload situation that did cause us issues. I cannot be sure that it
> is "excactly" the same problem we're seeing but symptoms are
> identical.
> 

Do you see the "page allocation failure" warnings on bare metal hosts
too? If so, then maybe we're dealing with a problem that isn't
virtio_net specific. In any case, let's get some folks more familiar
with that area involved first and take it from there.

Feel free to cc me on the bug report too.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

