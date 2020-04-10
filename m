Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 230831A42D4
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Apr 2020 09:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbgDJHNx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 10 Apr 2020 03:13:53 -0400
Received: from mail-lj1-f174.google.com ([209.85.208.174]:41143 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgDJHNw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 10 Apr 2020 03:13:52 -0400
Received: by mail-lj1-f174.google.com with SMTP id n17so1033971lji.8
        for <ceph-devel@vger.kernel.org>; Fri, 10 Apr 2020 00:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oGWjaZXAoIVj9dwZdAVxGE0is6GWQu2+YEEd9oQQzPc=;
        b=tnLx8q5xAI6dqsMp6y/C91XTVc9r9bVSyjN5ZPneKido+alFuoN17oiTdBxw1Fy1qf
         bz/f4LtPgXhIkz7YH3a0NUsBNXfMFjs/xf27jXXfIrCjKc1XJU01RDSFWclk8NxIO581
         vDqLQbgm70CXtwSlQqIzoIJK5d1jY+4Z4yCg6K3gLHh+Hqwf5G8ttIh5ilJiQPClUvqu
         za1UQGue06Qs5FzSOrq1KzDtFDPi2vLRfie/lJv4ZY3LhTDhmZW2ncJzDpzXgshI/tal
         a2ZEEDB4/hQEeUn/VGiSERhJ8P+cB3oLBawx8ygxoywgxkP+h5wFyezk0exOWSCY5Ex9
         lTXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oGWjaZXAoIVj9dwZdAVxGE0is6GWQu2+YEEd9oQQzPc=;
        b=Q7J3niw/bzciUKPeM9i590vBiqC8zJaQQ+OvpEpJNlwD76lvnGU3U2GHW4c1Hd4aFu
         Tx+mPjEcrkv8SwlV4uzYtdMtyuV1hGAtFX45lTE11wMbd86/gjWk5k71qDwzS4S/yvV0
         14IMOyHQeRvGdnZ232nLkutaOdoUsS9VfWDE7m6v9Da15LBmVzaDiRPMkMcaHBTToeV2
         qIFE/zhUSAh379ErIbgvePWjISfmUhXmlkvyYljIbWGVtYe7XFFu4yoUY+xeQB2F651p
         hi9xD9IJuplVvFC9gKZ2xemWj2918ixQBkrfxFJ0z87AKsl9o7D5+K3+Es8X3KC+YwoY
         RtPQ==
X-Gm-Message-State: AGi0PuYP0idwjZ6pCBJqJmhhRyi342d5U7X/klwwpx67IxhsY/szfOZ/
        tw4KfulJJ8vAIxsBvW3RhGWNE7z4GYD5KLG2F8rSrA==
X-Google-Smtp-Source: APiQypJinrDFPlHsbpgP6Lrl55yVfkyHSFmsAoNkuzq1zZJ9seJjkyMJweZZibNjajbO0x600iqc0DE+oYCY3kWT9hw=
X-Received: by 2002:a2e:3c08:: with SMTP id j8mr2227732lja.243.1586502831079;
 Fri, 10 Apr 2020 00:13:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAED-sidS3jt5f0nTvLp6_xL+sgk0FFJGaX-X7cCDav-8nwj4TA@mail.gmail.com>
 <db72c749125519b9c042c9664918eacbe8744985.camel@kernel.org>
 <CAED-sie+qsrr3yZVAiB=t6cAzWUwX9Y=32srJY2dwyRpSXvgxg@mail.gmail.com>
 <e9c9ffb60265aebdab6edd7ce1565402eb787270.camel@kernel.org>
 <CAED-sicefQuJ3GGWh2bBXz6R=BFr1EQ=h6Sz-W_mh3u+-tO0wA@mail.gmail.com>
 <cbbc31d2041601b3e0d2c9b1e8b657ffa23ed97e.camel@kernel.org>
 <CAED-sic=eDaXz-A6_ejZOYcJYs=-tJtmxXLcONdQRRCod59L_g@mail.gmail.com>
 <25bc975e164a73f18653156d6591dda785c8d0c1.camel@kernel.org> <f131fc4a-112d-2bea-f254-ed268579cf7e@ajlc.waterloo.on.ca>
In-Reply-To: <f131fc4a-112d-2bea-f254-ed268579cf7e@ajlc.waterloo.on.ca>
From:   Jesper Krogh <jesper.krogh@gmail.com>
Date:   Fri, 10 Apr 2020 09:13:39 +0200
Message-ID: <CAED-side70b+sXVFS8Tvh+4uPXWGuHC08hcA95p1yXmdpM_-wA@mail.gmail.com>
Subject: Re: 5.4.20 - high load - lots of incoming data - small data read.
To:     Tony Lill <ajlill@ajlc.waterloo.on.ca>
Cc:     Jeff Layton <jlayton@kernel.org>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi. What is the suggested change? - is it Ceph that has an rsize,wsize
of 64MB ?

On Fri, Apr 10, 2020 at 12:47 AM Tony Lill <ajlill@ajlc.waterloo.on.ca> wrote:
>
>
>
> On 4/9/20 12:30 PM, Jeff Layton wrote:
> > On Thu, 2020-04-09 at 18:00 +0200, Jesper Krogh wrote:
> >> Thanks Jeff - I'll try that.
> >>
> >> I would just add to the case that this is a problem we have had on a
> >> physical machine - but too many "other" workloads at the same time -
> >> so we isolated it off to a VM - assuming that it was the mixed
> >> workload situation that did cause us issues. I cannot be sure that it
> >> is "excactly" the same problem we're seeing but symptoms are
> >> identical.
> >>
> >
> > Do you see the "page allocation failure" warnings on bare metal hosts
> > too? If so, then maybe we're dealing with a problem that isn't
> > virtio_net specific. In any case, let's get some folks more familiar
> > with that area involved first and take it from there.
> >
> > Feel free to cc me on the bug report too.
> >
> > Thanks,
> >
>
> In 5.4.20, the default rsize and wsize is 64M. This has caused me page
> allocation failures in a different context. Try setting it to something
> sensible.
> --
> Tony Lill, OCT,                     ajlill@AJLC.Waterloo.ON.CA
> President, A. J. Lill Consultants               (519) 650 0660
> 539 Grand Valley Dr., Cambridge, Ont. N3H 2S2   (519) 241 2461
> -------------- http://www.ajlc.waterloo.on.ca/ ---------------
>
>
>
