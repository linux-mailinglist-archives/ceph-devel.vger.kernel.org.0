Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71712CA6FA
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Dec 2020 16:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391829AbgLAP0C (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Dec 2020 10:26:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32498 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391826AbgLAP0C (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Dec 2020 10:26:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606836276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Irzp8OgSK1lw1dO89IBdcDvBbyKLgifF6k2f+JMf2/I=;
        b=iOT9EN3o6/Or4SvX6T04YWJ/1164WDqQd8z1sIIEHd/b06siy+WfwrYtXTkbLURuw0A3VY
        1QqBrIKEeGqhf+B+NmYJXHZt8Cyz3hEBUfS4nkMJ8UIFCjVxXf+UrTMBcea7i4qcMUUAyV
        cLr9jUcAh30UIgYJFPyaJJn0LwWLv2k=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-176-CM1s1SbCMuKb-pKlJWnA6Q-1; Tue, 01 Dec 2020 10:24:33 -0500
X-MC-Unique: CM1s1SbCMuKb-pKlJWnA6Q-1
Received: by mail-qt1-f199.google.com with SMTP id z8so1501997qti.17
        for <ceph-devel@vger.kernel.org>; Tue, 01 Dec 2020 07:24:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Irzp8OgSK1lw1dO89IBdcDvBbyKLgifF6k2f+JMf2/I=;
        b=hX7ae0vHU/xUrEUYJqOeYx2FSaO37UgDsDZD9WJZ1BBEFVTKf1Qu5bYEmmOy/rn1bl
         +wAz7TYIJ8N9nhhMeu1BYqN7OvKvpkQZdMBdPUwV5mwhRdgX7UaQq3q4jC1Q68892eSE
         Mqww2/Wwvw9VvhWpNQ0NDO0rqGPhHV1SIl6iTMyGsHzO0KkNKSGSpjFXs/7otZr9Pdy/
         6CKzp18MGWC2dGegpjti1jj+sp0Zjit0VT4DTWJra/pjiu1qDb3ao06l4S0yBu+2q+vY
         5S91xI0zGNjLW4gMetc+hP0p5Em0Ga/VKu1L4qfd8OFhHfsdB5DpqdhtgTPjWnwQnk1b
         t7qA==
X-Gm-Message-State: AOAM5306yc09Nlq8mNzkS6Q0PMdAQBrELbVu/OUbKktyL4xm3Tbf0//j
        Dwl2aRwwhomXq9iuAI+ihC96m8X+emnUT2vkCzbyl+2FpB10wMXp0Sq6PJGR8wg4aw7BWinpeku
        EiDp6ngiwN8JuZGbcC8i2tg==
X-Received: by 2002:aed:2962:: with SMTP id s89mr3387423qtd.88.1606836272878;
        Tue, 01 Dec 2020 07:24:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwbKaYMdTZaLIGg6ae51+neuCgO/0VBeM1zCaV2HKzFA33ELLi6BXwdTMFb7TB18kmu/+kHtw==
X-Received: by 2002:aed:2962:: with SMTP id s89mr3387399qtd.88.1606836272469;
        Tue, 01 Dec 2020 07:24:32 -0800 (PST)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id 199sm1958190qkm.62.2020.12.01.07.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 07:24:32 -0800 (PST)
Message-ID: <aa38cc3b2ed96fed0dbee443fed564ac8d1a151d.camel@redhat.com>
Subject: Re: provisioning clients in teuthology with an extra local
 filesystem
From:   Jeff Layton <jlayton@redhat.com>
To:     David Galloway <dgallowa@redhat.com>
Cc:     dev <dev@ceph.io>, Ceph Development <ceph-devel@vger.kernel.org>,
        sepia <sepia@ceph.io>
Date:   Tue, 01 Dec 2020 10:24:31 -0500
In-Reply-To: <ad5a9630-daa0-b379-c7f4-5a9a139cd3a5@redhat.com>
References: <36b421ea14b3b14226b3e7c0407876886bb74e08.camel@redhat.com>
         <ad5a9630-daa0-b379-c7f4-5a9a139cd3a5@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-12-01 at 10:22 -0500, David Galloway wrote:
> On 12/1/20 9:55 AM, Jeff Layton wrote:
> > I've been working on a patch series to overhaul the fscache code in the
> > kclient. I also have this (really old) tracker to add fscache testing to
> > teuthology:
> > 
> >     https://tracker.ceph.com/issues/6373
> > 
> > It would be ideal if the clients in such testing had a dedicated
> > filesystem mounted on /var/cache/fscache, so that if it fills up it
> > doesn't take down the rootfs with it. We'll also need to have
> > cachefilesd installed and running in the client hosts.
> > 
> > Is it possible to do this in teuthology? How would I approach this?
> > 
> 
> I think I can make this happen pretty easily in ceph-cm-ansible.  What
> I'd need from you is desired filesystem type and size.  Once I'm done
> with my end, we'll need to create a cephlab.ansible overrides yaml
> fragment to stick in that suite's qa directory.
> 

Ok, cool:

fstype: xfs or ext4 (either is fine)
size: ~50g or so would be ideal, but we can probably get away with less 
      if necessary

Thanks!
-- 
Jeff Layton <jlayton@redhat.com>

