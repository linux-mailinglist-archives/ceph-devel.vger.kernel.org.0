Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9AC3BA3D2
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Jul 2021 20:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhGBSIr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 2 Jul 2021 14:08:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53219 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229455AbhGBSIr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 2 Jul 2021 14:08:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625249173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ooZkD7eTtrGGUaQJ74CSokbPUl7xvYsQW1e5E5FeMnA=;
        b=hAwDA9wukOxc3tBR4b88jjLqd/oj561j7CyYfHCxxTixNOkdAf+t5fTf2NZALdqCAZwx65
        kOpivW3Mp0b0LcmvrEvHags9CgU7kdwYF85j3se0F0BQYj3bYYSCYFtTOMaX2ASJW9xdQX
        9VEjv8QTYVx9LSQWbd5bcbng8dOdoN8=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-1VqahMCLPCKBo9bZH3uVzg-1; Fri, 02 Jul 2021 14:06:12 -0400
X-MC-Unique: 1VqahMCLPCKBo9bZH3uVzg-1
Received: by mail-io1-f69.google.com with SMTP id z11-20020a05660229cbb029043af67da217so7462256ioq.3
        for <ceph-devel@vger.kernel.org>; Fri, 02 Jul 2021 11:06:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ooZkD7eTtrGGUaQJ74CSokbPUl7xvYsQW1e5E5FeMnA=;
        b=lielGjuOscNRJSGNDLjTgMwf837Rw/76Hp/ulZ71AZL5hEmS5vksWRdbACppgVn4Hd
         Q3muSSVG0IiLf8jQ/1HF4MGlw0zyKg2Sng//TeCM3w4HOOoa2Zw8zge80jua7LjNUOBG
         og4WE1CzlLsXBSMeVkZTeybSyjYcNarL5sSrtWDAfvAY5aeUvjau7H1iDkmNgjBP9P9A
         tTQkMOUDKj7iXyu5RYX2YouAjugVoKoPP9vspWs9z6RjQGh0yxBhm2qL01H/4LQe9uG6
         lXMnSFGBvEka2J/L/FXmRGZUSNAwyTSlsZONNKQJmwulm88NMNY81ky2gYjLmR0wCWDB
         uDAA==
X-Gm-Message-State: AOAM530V/lChyspKy3Ef8vjCP13SdGIY+kFx9NNkDzZNxfy4B/PP1zvN
        l43Te7h3YkfxkpNwh8BwiNkAjh1r+IC5BlWIt7BQYPk9F6MWKk88CPNdlVXwZz7kLJXAYYJnvD1
        alXiBFH4YMp/m5NKDjGyTeEVRuGwXPIZCuEFhjg==
X-Received: by 2002:a92:de45:: with SMTP id e5mr808874ilr.157.1625249172221;
        Fri, 02 Jul 2021 11:06:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/5vuPXARYpRwd9pT+1ECNWBnMdC9yjp0vRVYME28jk2BPrycFU1RacPaK+IDCU+lzLo039UPPIYTtKlb0wbY=
X-Received: by 2002:a92:de45:: with SMTP id e5mr808861ilr.157.1625249172057;
 Fri, 02 Jul 2021 11:06:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210702064821.148063-1-vshankar@redhat.com>
In-Reply-To: <20210702064821.148063-1-vshankar@redhat.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Fri, 2 Jul 2021 11:05:46 -0700
Message-ID: <CA+2bHPbxR94_Bc-C5Ly7HQvwQPsoBr-j+fomGkTcBM5=8aS=0g@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] ceph: new mount device syntax
To:     Venky Shankar <vshankar@redhat.com>
Cc:     Jeff Layton <jlayton@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>, lhenriques@suse.de,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jul 1, 2021 at 11:48 PM Venky Shankar <vshankar@redhat.com> wrote:
> Also note that the userspace mount helper tool is backward
> compatible. I.e., the mount helper will fallback to using
> old syntax after trying to mount with the new syntax.

The kernel is also backwards compatible too, right?

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Principal Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

