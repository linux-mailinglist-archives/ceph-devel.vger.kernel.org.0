Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC5D9FBD2
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Apr 2019 16:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbfD3OrY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Tue, 30 Apr 2019 10:47:24 -0400
Received: from mailpro.odiso.net ([89.248.211.110]:34866 "EHLO
        mailpro.odiso.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfD3OrY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 30 Apr 2019 10:47:24 -0400
X-Greylist: delayed 484 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Apr 2019 10:47:22 EDT
Received: from localhost (localhost [127.0.0.1])
        by mailpro.odiso.net (Postfix) with ESMTP id 81F0A13879FF;
        Tue, 30 Apr 2019 16:39:17 +0200 (CEST)
Received: from mailpro.odiso.net ([127.0.0.1])
        by localhost (mailpro.odiso.net [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id wTd1fNttHy_d; Tue, 30 Apr 2019 16:39:17 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mailpro.odiso.net (Postfix) with ESMTP id 6829E1387A00;
        Tue, 30 Apr 2019 16:39:17 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mailpro.odiso.com
Received: from mailpro.odiso.net ([127.0.0.1])
        by localhost (mailpro.odiso.net [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id qLM9BFSTAjme; Tue, 30 Apr 2019 16:39:17 +0200 (CEST)
Received: from mailpro.odiso.net (mailpro.odiso.net [10.1.31.111])
        by mailpro.odiso.net (Postfix) with ESMTP id 4EFA613879FF;
        Tue, 30 Apr 2019 16:39:17 +0200 (CEST)
Date:   Tue, 30 Apr 2019 16:39:17 +0200 (CEST)
From:   Alexandre DERUMIER <aderumier@odiso.com>
To:     Vitaliy Filippov <vitalif@yourcmc.ru>
Cc:     dillaman <dillaman@redhat.com>,
        Mark Nelson <mark.a.nelson@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        ceph-devel-owner@vger.kernel.org
Message-ID: <1073621142.34700.1556635157095.JavaMail.zimbra@odiso.com>
In-Reply-To: <op.zzrr5qn20ncgu9@localhost>
References: <6b33c8575b138ce15d80888f11d4c27b@yourcmc.ru> <CA+aFP1Cn9wbPwYcMFNsb7vt-bswqr4FNdLn3VvR+a0EJ0KQtBA@mail.gmail.com> <441F053D-00E0-4DFD-8AC8-E0B2462E7307@yourcmc.ru> <CA+aFP1Ar07WF9Y_D5b499VcfzzeWePq5r5KBnoy3dg-aDm1PtQ@mail.gmail.com> <1820e599886429c9d6400b1b99723881@yourcmc.ru> <700f4982-c8ef-a24a-a963-a2ee80a9f777@gmail.com> <op.zzrr5qn20ncgu9@localhost>
Subject: Re: librados (librbd) slower than krbd
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Mailer: Zimbra 8.8.9_GA_3026 (ZimbraWebClient - GC71 (Linux)/8.8.9_GA_3042)
Thread-Topic: librados (librbd) slower than krbd
Thread-Index: sAVcGBHVuzJd1mGOKbonJxWaLuPEvA==
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

>>I can only see two things in valgrind profiles: "self" instruction count  
>>for buffer::list::append and friends are 24% and tcmalloc's are 15%. Crush  
>>calculation, which I had removed by caching it in my test, was taking 5.7%  
>>in that same profile, so... maybe if 5.7% stands for 0.015ms - could 24%  
>>stand for 0.075ms? :).

could be interesting to test fio with jemalloc instead tcmalloc

#export LD_PRELOAD=${JEMALLOC_PATH}/lib/libjemalloc.so.1 
#fio ....

In past, I had better results (In proxmox, we still use jemalloc in qemu)
http://lists.ceph.com/pipermail/cbt-ceph.com/2015-May/000019.html


----- Mail original -----
De: "Vitaliy Filippov" <vitalif@yourcmc.ru>
À: "dillaman" <dillaman@redhat.com>, "Mark Nelson" <mark.a.nelson@gmail.com>
Cc: "ceph-devel" <ceph-devel@vger.kernel.org>, ceph-devel-owner@vger.kernel.org
Envoyé: Vendredi 5 Avril 2019 12:45:16
Objet: Re: librados (librbd) slower than krbd

> Another big CPU drain is debug ms = 1. We recently decided to disable 
> it by default in master since the overhead is so high. You can see that 
> PR here: 
> 
> https://github.com/ceph/ceph/pull/26936 

Okaaay, thanks, after disabling it the latency difference between krbd and 
librbd slightly dropped, now it is like 0.57ms (krbd) vs 0.63ms (librbd) 
in my setup. It's becoming not bad overall since I'm approaching 0.5ms 
latency... :) 

I also tried to make a patch for librados which makes it not recalculate 
PG OSDs for every operation, it also helps, but only slightly by reducing 
latency by 0.015ms :) (and probably only usable in small clusters with a 
small number of PGs). 

I still can't really understand what's making librados so slow... Is it 
just the C++ code?.. :) 

I can only see two things in valgrind profiles: "self" instruction count 
for buffer::list::append and friends are 24% and tcmalloc's are 15%. Crush 
calculation, which I had removed by caching it in my test, was taking 5.7% 
in that same profile, so... maybe if 5.7% stands for 0.015ms - could 24% 
stand for 0.075ms? :). 

It seems buffer::list::append is called a lot of times, basically for each 
field of the output structure. Could it be better to allocate several 
fields at once and fill them by simple assignments or was I just digging 
in the wrong direction and most of the overhead originated from the 
copying of the original buffer (which is invisible in the profile)? 

> and the associated performance data: 
> 
> https://docs.google.com/spreadsheets/d/1Zi3MFtvwLzCFfObL6evQKYtINQVQIjZ0SXczG78AnJM/edit?usp=sharing 
> 
> Mark 


-- 
With best regards, 
Vitaliy Filippov 

