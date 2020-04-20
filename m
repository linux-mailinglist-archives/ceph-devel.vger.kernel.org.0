Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049D01B0E34
	for <lists+ceph-devel@lfdr.de>; Mon, 20 Apr 2020 16:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729762AbgDTOVP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 20 Apr 2020 10:21:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727890AbgDTOVO (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 20 Apr 2020 10:21:14 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB84B20722;
        Mon, 20 Apr 2020 14:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587392474;
        bh=vsjKdAH7UkbL47Ql4HW+M0eWWOjY4LdGovS6OoGv2JI=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=2cIb+Dy+xdXJ7VxUOoHIItiXOfqDTGbuG2JTzvxhdwww5VFcAmYdHPCj9ew3VRakn
         ekARHSJGv9L4+tZhJWmKfe+beWWjFhUQKbRJFEvm74qnoLWVaTL+dvSAyrjHvQ2yee
         Vl7iK+Kg7K+x39uOpFDcyqDylFfLuhHnLmDg0hDY=
Message-ID: <cc2b7b3f2601aa6ab3698bd9d12a6c4c34076e9d.camel@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: remove myself as ceph co-maintainer
From:   Jeff Layton <jlayton@kernel.org>
To:     Sage Weil <sweil@redhat.com>, ceph-devel@vger.kernel.org
Date:   Mon, 20 Apr 2020 10:21:12 -0400
In-Reply-To: <alpine.DEB.2.21.2004201343420.29831@piezo.novalocal>
References: <alpine.DEB.2.21.2004201343420.29831@piezo.novalocal>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-04-20 at 13:44 +0000, Sage Weil wrote:
> Jeff, Ilya, and Dongsheng are doing all of the Ceph maintainance
> these days.
> 
> Signed-off-by: Sage Weil <sage@redhat.com>
> ---
>  MAINTAINERS | 3 ---
>  1 file changed, 3 deletions(-)
> 

Merged -- should make v5.8 (or could go in sooner if we have follow-on
fixes).

Thanks for all the contributions over the years! Any time you want to
get back into kernel work, just let us know. ;)

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

