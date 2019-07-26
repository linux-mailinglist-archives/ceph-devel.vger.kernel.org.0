Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C445976760
	for <lists+ceph-devel@lfdr.de>; Fri, 26 Jul 2019 15:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbfGZNZu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 26 Jul 2019 09:25:50 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44743 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727375AbfGZNZt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 26 Jul 2019 09:25:49 -0400
Received: by mail-lj1-f196.google.com with SMTP id k18so51459242ljc.11
        for <ceph-devel@vger.kernel.org>; Fri, 26 Jul 2019 06:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XPtS6ED+jMsCmLsIUdpymt2uSsOTDiI/hof6/QZOZBc=;
        b=Dv2HSwFi71w104X2GaSQGMu6Z+KAjRY7rO86yzO52kNwXYAncNz4nPuLX4rIzeaqdn
         mfB4IKdAdMxiB3i/dbwRfsmZduzl/gk1n9hlwdB0PfEEHSiPGxr+CcdB3xViCYQ94ziq
         VIqYpX9oWRLp5FldJYcjB0fizuYM4fROA/pAW80c6laDe45E9ktoyd/iKBNMTwhMWz+t
         eNKZkzkG+BuW/LeXyupVzmuJ/TtO9G4oyzg5duR2YB2crQbKyvTE567h4N+KXriBlant
         MjlSkQpAyr3QdjbCY1/Iq+0lHH4karpsBBRvDocoy2qXAc7NSxgrEb+lduo/ibRE9jGF
         uceA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XPtS6ED+jMsCmLsIUdpymt2uSsOTDiI/hof6/QZOZBc=;
        b=qAOP5+iKpm3IHqVuwKKyu3e7NeO3IESD6OrM1d8zyKab0j6Cr6B4sOAA7/phhKEl4k
         945JIQ2wnkEXP5283VGzIHkQ2LOZs+p12LSA7K7A20C+bE6kqxmBnEAEgTho6Rdm2yox
         4l0OFBs+dbz/p7DdQQ2TInFmaqE1A++7NBROSbHoxPoDaPNPWUvjJQk7YO0+53Hk1dn8
         KBaH5ReHop4EPyldbld/Uz8vaIubDpHK4sZFd4VjGn7ChWuAZTJ7qX13nu+oBKsNZlMe
         8WwE3KYPwjcEWNJim950Yu6RP1BxV7wPIhkGckuQVT++e21yIRdEG3bdgtitO1/megz9
         Pzew==
X-Gm-Message-State: APjAAAV725/C6qrhbDCbDpvnKTnVZYykByr5F9FtKBRv4JgT8ZvXOnk7
        gRekdxZdWTmme4jzsQTWNQ==
X-Google-Smtp-Source: APXvYqxWqeCus7jNiK8qNYE3he6hRXQpROx24jlOv11F7DwAyq7JfV8N3W7Z1YnajBkrbBpddfu+Og==
X-Received: by 2002:a2e:2411:: with SMTP id k17mr11061240ljk.136.1564147548219;
        Fri, 26 Jul 2019 06:25:48 -0700 (PDT)
Received: from localhost ([91.245.78.132])
        by smtp.gmail.com with ESMTPSA id u21sm10122020lju.2.2019.07.26.06.25.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 06:25:47 -0700 (PDT)
From:   Mykola Golub <to.my.trociny@gmail.com>
X-Google-Original-From: Mykola Golub <mgolub@suse.de>
Date:   Fri, 26 Jul 2019 16:25:46 +0300
To:     Ajitha Robert <ajitharobert01@gmail.com>
Cc:     Mykola Golub <to.my.trociny@gmail.com>, ceph-users@lists.ceph.com,
        ceph-users@ceph.com, ceph-devel@vger.kernel.org
Subject: Re: [ceph-users] Error in ceph rbd
 mirroring(rbd::mirror::InstanceWatcher: C_NotifyInstanceRequestfinish:
 resending after timeout)
Message-ID: <20190726132546.GA6825@gmail.com>
References: <CAEbG6hG7dAhg=Z9JUKcCCTOEPyXZ6cZcS=jar7SeL-5VTcqEgA@mail.gmail.com>
 <20190726093147.GA31242@gmail.com>
 <CAEbG6hFgvWFMgaYHRRtZdth-OkJ7ib4vWxf__b7QvGPd1rF6Qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEbG6hFgvWFMgaYHRRtZdth-OkJ7ib4vWxf__b7QvGPd1rF6Qg@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jul 26, 2019 at 04:40:35PM +0530, Ajitha Robert wrote:
> Thank you for the clarification.
> 
> But i was trying with openstack-cinder.. when i load some data into the
> volume around 50gb, the image sync will stop by 5 % or something within
> 15%...  What could be the reason?

I suppose you see image sync stop in mirror status output? Could you
please provide an example? And I suppose you don't see any other
messages in rbd-mirror log apart from what you have already posted?
Depending on configuration rbd-mirror might log in several logs. Could
you please try to find all its logs? `lsof |grep 'rbd-mirror.*log'`
may be useful for this.

BTW, what rbd-mirror version are you running?

-- 
Mykola Golub
