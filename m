Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1217C551BD
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Jun 2019 16:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730505AbfFYObd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Tue, 25 Jun 2019 10:31:33 -0400
Received: from mail-qk1-f180.google.com ([209.85.222.180]:40760 "EHLO
        mail-qk1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727730AbfFYObd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jun 2019 10:31:33 -0400
Received: by mail-qk1-f180.google.com with SMTP id c70so12744135qkg.7
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jun 2019 07:31:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LhB9tw+6Rxd7xpBD+3efceh3yawGzZkW+XHflRNvBCQ=;
        b=Y8mZXrdso7C7rUPWv7rZyjXYUZpB0Z6M/ThOcNpxz/HhfnjOzS+ydYcc1GghN5HVo3
         E6Nk8ROTGwbzDllWnKjMVARp7AfTjOL4qB4RjxqY+cg8hFlPDc5Br0OTWwrydxQ32hfe
         TT7Z4myFOgdHhTGMGlWHhY5qY45UAZhezhrA5o3WUdsI75G/cbYdDCUQ+hDINkISUCCo
         lgCBE3/9yOQgJ/z7frYcyG4A//pdyUPZOsxUwJ0R0DJM9ARF4mDcqxYgTJjGg4h21uPR
         stnZ7IBV4cQROlJ1OnWFx84tIESHAuszAYmZwvsL0bSmlllJ4T/3iiks+m/dWc9jLfsf
         qZKA==
X-Gm-Message-State: APjAAAUUveyoVAEdNgfugywwYJJBndTQhgPKtdOJ3WTl67iSVlkRGUxi
        ALckZGMXOe0AAP3ixDrukB3hu6K4VngPeUoKuCU4pOlBm+o=
X-Google-Smtp-Source: APXvYqzuevIBO4F5FqjMs3kCtjSEVtM9CPYkM8hzsAkKcdHSQmrkZBQTDCgTNuFNYKz9I0IUekizE/bRSCbH8KNPq8g=
X-Received: by 2002:a37:4e0d:: with SMTP id c13mr32936813qkb.116.1561473092353;
 Tue, 25 Jun 2019 07:31:32 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.11.1906051556500.987@piezo.novalocal>
 <alpine.DEB.2.11.1906171621000.20504@piezo.novalocal> <CAN-Gep+9bxadHMTFQgUFUt_q9Jmfpy3MPU5UTTRNY1jueu7n9w@mail.gmail.com>
In-Reply-To: <CAN-Gep+9bxadHMTFQgUFUt_q9Jmfpy3MPU5UTTRNY1jueu7n9w@mail.gmail.com>
From:   Alfredo Deza <adeza@redhat.com>
Date:   Tue, 25 Jun 2019 10:31:21 -0400
Message-ID: <CAC-Np1zcniBxm84SEGhzYfu55t+fckg1d-Dq0xpab62+ON4K5w@mail.gmail.com>
Subject: Re: [ceph-users] Changing the release cadence
To:     David Turner <drakonstein@gmail.com>
Cc:     Sage Weil <sage@newdream.net>,
        Ceph Devel <ceph-devel@vger.kernel.org>,
        Ceph-User <ceph-users@ceph.com>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jun 17, 2019 at 4:09 PM David Turner <drakonstein@gmail.com> wrote:
>
> This was a little long to respond with on Twitter, so I thought I'd share my thoughts here. I love the idea of a 12 month cadence. I like October because admins aren't upgrading production within the first few months of a new release. It gives it plenty of time to be stable for the OS distros as well as giving admins something low-key to work on over the holidays with testing the new releases in stage/QA.

October sounds ideal, but in reality, we haven't been able to release
right on time as long as I can remember. Realistically, if we set
October, we are probably going to get into November/December.

For example, Nautilus was set to release in February and we got it out
late in late March (Almost April)

Would love to see more of a discussion around solving the problem of
releasing when we say we are going to - so that we can then choose
what the cadence is.

>
> On Mon, Jun 17, 2019 at 12:22 PM Sage Weil <sage@newdream.net> wrote:
>>
>> On Wed, 5 Jun 2019, Sage Weil wrote:
>> > That brings us to an important decision: what time of year should we
>> > release?  Once we pick the timing, we'll be releasing at that time *every
>> > year* for each release (barring another schedule shift, which we want to
>> > avoid), so let's choose carefully!
>>
>> I've put up a twitter poll:
>>
>>         https://twitter.com/liewegas/status/1140655233430970369
>>
>> Thanks!
>> sage
>> _______________________________________________
>> ceph-users mailing list
>> ceph-users@lists.ceph.com
>> http://lists.ceph.com/listinfo.cgi/ceph-users-ceph.com
>
> _______________________________________________
> ceph-users mailing list
> ceph-users@lists.ceph.com
> http://lists.ceph.com/listinfo.cgi/ceph-users-ceph.com
