Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAC1378F7C
	for <lists+ceph-devel@lfdr.de>; Mon, 10 May 2021 15:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbhEJNrv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 10 May 2021 09:47:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44752 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230477AbhEJNbR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 10 May 2021 09:31:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620653409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eUUaS1PEFgooJWN901G6RACHtcUxmowPwMmDUybvyL8=;
        b=WSux+woYFtAtmlcpmGs7fi3etgKIrHZFqAf79DH3DFdH9wbEZ8zRmeB3wNuzWrpc8Wueka
        sb5fiZ46EzKRj1tf48/WG/S7CbQkmG3p5hj9trYNOHMRNyRlXKi3YmPjEKBE/+A+CpDX53
        kCii5aHg384RbvwDF8SFOAQmND24k78=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-EVgatifcM9qwaj94bXxE4g-1; Mon, 10 May 2021 09:30:07 -0400
X-MC-Unique: EVgatifcM9qwaj94bXxE4g-1
Received: by mail-qv1-f72.google.com with SMTP id c5-20020a0ca9c50000b02901aede9b5061so12533599qvb.14
        for <ceph-devel@vger.kernel.org>; Mon, 10 May 2021 06:30:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=eUUaS1PEFgooJWN901G6RACHtcUxmowPwMmDUybvyL8=;
        b=t6/8mlBajSlS8Ce9Q8SHVtIB1V44hIxrWfIZOTduwiKKjYJFgfMeSk7RsMeZIsnofp
         7/mrNVdQ9/E321OM7ChE87uuLLyunLF7wl6ZTAYZI2Bh6xf0HjjCKNloSP9p0gGiRrAJ
         twR2q2iGqxCbvEElFpWB3LPSiMQigA2NX2mg2OKoOewwuY01FZtHU/EWkqNM7DpEegVS
         KBoFXjM9gQ8sbjJR3woRjtpkEuEklccQ0V8hFzIyzg8Po58HQr6f8TdmNuFk+ru6lHKK
         on3TREh3sleO6EUsgTvyPUpp3Wn503mtegPDYlaEPG5cjDAfjrBs7aU9gjJfXRPE7onJ
         uxxA==
X-Gm-Message-State: AOAM530FQdCtkRkEHY/Vb9S39vukX19EIDAr2WTpDZT+UfaFAuNd3JOE
        f2olV7xPdigKgBMhvcFDhehrmc24Zy/ASN87ED/I7csyjGCrLcprlakVRjmxg2VpyY6HbwNMXjA
        6PBB9PByS3XRUIHpFJJq2+w==
X-Received: by 2002:a37:9f48:: with SMTP id i69mr23010221qke.28.1620653407411;
        Mon, 10 May 2021 06:30:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgxm0XLQ0fim+rz2rcFkbMCGU+k6a7NuhRT1L97qN09TMcUQoowZ3glP/4FIb7jhz0UVTdog==
X-Received: by 2002:a37:9f48:: with SMTP id i69mr23010195qke.28.1620653407180;
        Mon, 10 May 2021 06:30:07 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id z9sm1021925qtf.10.2021.05.10.06.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 06:30:06 -0700 (PDT)
Message-ID: <fbcb28d9bd8d50ef47750931904fabb78f28d182.camel@redhat.com>
Subject: Re: Ceph Kernel client bad performance for 5.4
From:   Jeff Layton <jlayton@redhat.com>
To:     "Norman.Kern" <norman.kern@gmx.com>, ceph-devel@vger.kernel.org
Date:   Mon, 10 May 2021 09:30:06 -0400
In-Reply-To: <4badb69d-515f-ec30-5966-d26e145884bd@gmx.com>
References: <4badb69d-515f-ec30-5966-d26e145884bd@gmx.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, 2021-05-08 at 10:13 +0800, Norman.Kern wrote:
> Hi, guys,
> 
> 
> I'm using ceph nautilus in my production,  the kernel clients include 5.4 and 4.15, I found a problem in 5.4 sometimes: It's slower than fuse, but when I changed it
> to 4.15, it's recovered.
> for 5.4:
> root@WXRG0432:/mnt/test# rsync -ahHv --progress /root/test test-1
> sending incremental file list
> test
>          58.56M   5%    2.82MB/s    0:05:43  ^C
> for 4.15:
> root@WXRG0433:/mnt/test# rsync -ahHv --progress /root/test  test-2
> sending incremental file list
> test
>           1.05G 100%  316.25MB/s    0:00:03 (xfr#1, to-chk=0/1)
> 
> sent 1.05G bytes  received 35 bytes  299.67M bytes/sec
> Anyone have met the same problems with me?

v5.4 is quite old at this point. It would be good to also test something
newer if you're able. Something v5.12-ish would be ideal.

It's not clear what, exactly, you're testing here, but it looks like the
slowdown is in write activity. A slowdown of that magnitude sounds like
the client has stopped doing buffered I/O, but it's hard to say for
sure.

You may want to run both of these under strace, collecting syscall
timing and see if you can narrow down which syscalls are seeing the
biggest slowdowns. That may help us narrow down what's happening.

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>

