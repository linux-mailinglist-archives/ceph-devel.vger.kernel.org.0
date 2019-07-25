Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 430F075786
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2019 21:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbfGYTEA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Jul 2019 15:04:00 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35071 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfGYTEA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Jul 2019 15:04:00 -0400
Received: by mail-qt1-f194.google.com with SMTP id d23so50198358qto.2
        for <ceph-devel@vger.kernel.org>; Thu, 25 Jul 2019 12:03:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B4JfqR8D6A7I4QgzBdlUtFW8HrnRRef9HAz5nrKb9rM=;
        b=ufzJkO5M79YtyddclpFEU2AmlUC9mihhxZ752PvnvmWwyCL//2ZdL0xmuudQ1mvxfQ
         4SDbxwMUtLz114ghTD0T+nENGNUne8NW9J4JrqdmXuHtLApYdlUzyWMehvilCwQ5iGpk
         vjga4pu0C6o8PTA5s+WFoNQ3i421OrH1c5W4ZqwrWYdKW4zAos6zWJAhsNEbH7W6yqi5
         +3dfSWTf+8nXsqiJbEGdwyKGmWqr//rxFH1rOdp6MYobnAMiGUR/D+N+yZ8FLJo6U+29
         JC7aV2ZIa9GsXE7x//iFGqVP8nMz4L7i63h/PHUPyR45sWFty8zC4jjrX75sHhsJfsSw
         zJ1w==
X-Gm-Message-State: APjAAAVgDKFa6cOiCFt0f5CuAQJNVAsJ7F75sgJiMgWfYCe9hsZKSt23
        BLa8nL53KkWbZlh+VI/PE8eV9+JGXCrujsSmCqZUrg==
X-Google-Smtp-Source: APXvYqz2N/hUYtz1oHIDEXT7RSvIsqZesT9RNwpcPEwatQTC421EldKLNpC51ky8R/p6Ov9JUMUyyKZwkrQ2eus7c1M=
X-Received: by 2002:ad4:55a9:: with SMTP id f9mr64699304qvx.133.1564081439083;
 Thu, 25 Jul 2019 12:03:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190724172026.23999-1-jlayton@kernel.org> <87ftmu4fq3.fsf@suse.com>
 <20190725115458.21e304c6@suse.com> <fd396da29b62b83559d7489757a3871b7453e7fa.camel@kernel.org>
 <20190725135854.66c3be3d@suse.de>
In-Reply-To: <20190725135854.66c3be3d@suse.de>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Thu, 25 Jul 2019 12:03:33 -0700
Message-ID: <CA+2bHPbc86Kc9CSHj1PzZuEnY_8HLi1enAUjxTcNLuYREKvKmg@mail.gmail.com>
Subject: Re: [RFC PATCH] ceph: don't list vxattrs in listxattr()
To:     David Disseldorp <ddiss@suse.de>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Luis Henriques <lhenriques@suse.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jul 25, 2019 at 4:59 AM David Disseldorp <ddiss@suse.de> wrote:
>
> On Thu, 25 Jul 2019 07:17:11 -0400, Jeff Layton wrote:
>
> > Yeah, I rolled a half-assed xfstests patch that did this, and HCH gave
> > it a NAK. He's probably right though, and fixing it in ceph.ko is a
> > better approach I think.
>
> It sounds as though Christoph's objection is to any use of a "ceph"
> xattr namespace for exposing CephFS specific information. I'm not sure
> what the alternatives would be, but I find the vxattrs much nicer for
> consumption compared to ioctls, etc.

Agreed. I don't understand the objection [1] at all.

If the issue is that utilities copying a file may also copy xattrs, I
don't understand why there would be an expectation that all xattrs are
copyable or should be copied.

[1] https://www.spinics.net/lists/fstests/msg12282.html

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
