Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C519FA91A8
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Sep 2019 21:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388517AbfIDSVj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Wed, 4 Sep 2019 14:21:39 -0400
Received: from pdx1-sub0-mail-fallback-mx1.dreamhost.com ([64.90.62.139]:52078
        "EHLO pdx1-sub0-mail-fallback-mx1.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388933AbfIDSVi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 4 Sep 2019 14:21:38 -0400
X-Greylist: delayed 21640 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Sep 2019 14:21:38 EDT
Received: from pdx1-sub0-mail-mx62.g.dreamhost.com (unknown [10.35.43.107])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by pdx1-sub0-mail-fallback-mx1.dreamhost.com (Postfix) with ESMTPS id 9A2A117D1EF
        for <ceph-devel@vger.kernel.org>; Wed,  4 Sep 2019 05:20:57 -0700 (PDT)
Received: from vade-backend20.dreamhost.com (fltr-in2.mail.dreamhost.com [66.33.205.213])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by pdx1-sub0-mail-mx62.g.dreamhost.com (Postfix) with ESMTPS id 08C5D851B1
        for <ceph-devel@ceph.com>; Wed,  4 Sep 2019 05:20:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
        by vade-backend20.dreamhost.com (Postfix) with ESMTPS id 7ABDA400001FB
        for <ceph-devel@ceph.com>; Wed,  4 Sep 2019 05:20:56 -0700 (PDT)
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A6DB6883CA
        for <ceph-devel@ceph.com>; Wed,  4 Sep 2019 12:20:55 +0000 (UTC)
Received: by mail-ed1-f70.google.com with SMTP id e13so4660966edl.13
        for <ceph-devel@ceph.com>; Wed, 04 Sep 2019 05:20:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=9zHcvmKGmur3OvLsGSLQkhu+pyC/lNLSBIGP+ii3kno=;
        b=ckWRxBwJ0ZcVdLLque44vO2rtoqpziEdEtZVUGE6ZLfPfIG3QV10XzodoyneQCrrAh
         ZBcHr0hCTGU/HqZhjZmrM+bjuED0D5EIc2d0OR8QV9dqeRQswaaJ2jHXP0LrZHG1h+hG
         RNJIZKU7Bwd5XjLDNXSVRA6FiCls0bfP5B0uJZnRw4YTOt9UKKfVrkXI4LyOoPJsKovR
         llZQfM1+cJR23W6VTXPFPu3H2sSWvC4fSMK8AYs8qkYhuw0e7R1BGWsHBZZNe5NNcVpI
         GEMV3ZElEj6SFKEfwPAZ9d5y9O5JF6EJZyTzRbgFHi8K+7PQFE4J4bW7C3xlu9J+R+ja
         aokg==
X-Gm-Message-State: APjAAAWlQBltUnXLFY/ou0xE8S6hTnTzjUEdF6HMxAiead77oDp4W9gn
        yKcK2KedqPdI9Huoh882JW9YswmF9o+NNOD2iiEXGaZrwOFrQpms2c6OFR0Mi+uOlQ7XhNsS5Vd
        wAJHhFwnSFHP1Jdx1NcaCRUhSeWs2
X-Received: by 2002:a17:906:70c3:: with SMTP id g3mr32205361ejk.195.1567599654125;
        Wed, 04 Sep 2019 05:20:54 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwm2S1UtMu4c/pvzhdm0poTEYnr5nWXvWp5tDQghS4YKbZcmDxsNDY61pMH4wTEwJ7otyS9ekvryDaxuoX0slI=
X-Received: by 2002:a17:906:70c3:: with SMTP id g3mr32205343ejk.195.1567599653795;
 Wed, 04 Sep 2019 05:20:53 -0700 (PDT)
MIME-Version: 1.0
References: <tencent_06FE934D0B94847E25783566@qq.com> <E5EB2B68-6F73-4639-A32E-09B023A2585A@redhat.com>
 <tencent_2A6CC6A10743C562379448D0@qq.com> <tencent_4CB49E3C5A13B24047F052E6@qq.com>
In-Reply-To: <tencent_4CB49E3C5A13B24047F052E6@qq.com>
Reply-To: dillaman@redhat.com
From:   Jason Dillaman <jdillama@redhat.com>
Date:   Wed, 4 Sep 2019 08:20:42 -0400
Message-ID: <CA+aFP1Bvf8yf-4DPRuk-oYU7Tdc1MxC+sysjMV3vpXsdKaCkfA@mail.gmail.com>
Subject: Re: request docs about the rbd migartion design and usage scenario
To:     =?UTF-8?B?546L5YuH?= <wangyong@szsandstone.com>
Cc:     ceph-devel@ceph.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-VR-STATUS: OK
X-VR-SCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduvddrudejhedghedtucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucenucfjughrpeggfhgjrhfhfffkuffvtgfgsehtqhertddttdejnecuhfhrohhmpeflrghsohhnucffihhllhgrmhgrnhcuoehjughilhhlrghmrgesrhgvughhrghtrdgtohhmqeenucfkphepvddtledrudefvddrudekfedrvdekpddvtdelrdekhedrvddtkedrjedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehmgidurdhrvgguhhgrthdrtghomhdpihhnvghtpedvtdelrddufedvrddukeefrddvkedprhgvthhurhhnqdhprghthheplfgrshhonhcuffhilhhlrghmrghnuceojhguihhllhgrmhgrsehrvgguhhgrthdrtghomheqpdhmrghilhhfrhhomhepjhguihhllhgrmhgrsehrvgguhhgrthdrtghomhdpnhhrtghpthhtoheptggvphhhqdguvghvvghlsegtvghphhdrtghomhenucevlhhushhtvghrufhiiigvpedt
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Sep 4, 2019 at 7:18 AM 王勇 <wangyong@szsandstone.com> wrote:
>
> Hi Jason,
> the rbd live-migration seems like two issues.
> 1、discard
> 1). discard one object （m_no =1000）
> 2). rbd execute current object (m_no=500)
> 3). rbd execute m_no=1000, object not exsits.  old data will overwrite new data.

A discard is a hint to free space and shouldn't be confused w/ a zero
operation. In this case, when a discard is issued against a clone (or
migration destination), it cannot just delete the object. Instead, it
creates a zero-byte object to ensure that it won't read from the
parent image in the future. When the "rbd migration execute"
eventually gets to the discarded object, there is a guard on the IO
operation to prevent it from writing to the object (which is the same
logic used to prevent old writes from the source image from
overwriting newer writes to the destination).

> 2、src image has clone image，
> rbd prepare need first close the src image, but no need to close close image.
> when rbd prepare ok, the clone image parent omap changed, but  in the librbd context of the clone image,
> it used the old parent. so clone image read will get the old data.

I'm not sure I understand what you mean here. What is the "clone"
image in your example here? The migration source or destination? In
the context of migration, the destination image has the source image's
parent as its parent, but it satisfies all reads by reading from the
source (and then the parent if required).

> could I get some discuss about those ?

In the future, please use the ceph-devel mailing list.

>
>
> ------------------ Original ------------------
> From:  "王勇"<wangyong@szsandstone.com>;
> Date:  Fri, Aug 30, 2019 11:28 AM
> To:  "Jason Dillaman"<jdillama@redhat.com>;
> Subject:  Re: request docs about the rbd migartion design and usage scenario
>
> Hi Jason,
> I had done review on the docs about the live migration.
> it designed 3 steps: prepare/execute/commit.
> did it should be better which designed just 1 step? it seems like to one double  things.
> do you have backgroud design docs or discuss for  those designe?
>
> Thanks and Regards.
> ------
> wang yong



-- 
Jason
