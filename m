Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D37C713816F
	for <lists+ceph-devel@lfdr.de>; Sat, 11 Jan 2020 14:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbgAKNkG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 11 Jan 2020 08:40:06 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:38578 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729294AbgAKNkG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 11 Jan 2020 08:40:06 -0500
Received: by mail-qv1-f67.google.com with SMTP id t6so2086066qvs.5
        for <ceph-devel@vger.kernel.org>; Sat, 11 Jan 2020 05:40:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qgljkZSM3AFHE6N5pDggS4w0yEUbWXbJ0f1UZ3MgO7E=;
        b=Gl7EDJPk6RwQQoTw3ubx/8nFkw5iQVy2IHvguquyAfmiAeoHb6HK7Wnzu9wmZ10AxM
         s6vvTeRjpd/SsTVSjZF7bTsyZ7QgkM5+amg8ykM4MQZIhHP9tmYStQd1+DSGXJ/DJFzm
         gN43DNRlvXxRFwZDgoxJuLkYRY4oZLYs+uu/bmENlXsWZtw1p13e5T96sLC1U4DXImTx
         otzr2YtFwpL+Qj2rW4xtAp2tgXflYUeDhwIJ0pNbmJ1g0MAMhhpBLSLwg8b+Rw01PaAp
         qUpM/VXgOhGBk7a3arieBEZp5age1zcW1ZNUbrAQ/cK+pioVEJXhdNKuAz5vHs+IromD
         pJdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qgljkZSM3AFHE6N5pDggS4w0yEUbWXbJ0f1UZ3MgO7E=;
        b=XzGulw5SLEAD/Rne5eTlKx7ZAA4N2atWW+MfIMePyLcamhCqnjrBt6yWTBMgZ6In6N
         NAHZKriQNmy75IVgUBX31veZ6ApUtcR0wDDwIDy76A2QYM+0C9qNZ1bmQdUVhz9U/gNe
         St7R+OGPrYBPSZ9WV0r07XCg3c4l6ocbDbtAF4OfuIfZLrFFW01W/LhKvtOSztfztZYr
         WA/R+tr0Q+WEjfj7s3p9pVpAHN6ylc5GjRa5Q4q5OZQdRL4pQuXCehAibBsLzhET5D7L
         SilRL5DdQUI9b9mFA2YM9H6+jitNjRwrmlyfdTgjSkMbal8jPfLOPvLdwALDRh03ljgo
         fwLw==
X-Gm-Message-State: APjAAAUrrHmxH1WXSfK9GyViJp+tAYEo9E7uFfsrBebggGpphb5dcziQ
        x1L0wt0aiCUrPnZKRptIQoQrlF1lupM=
X-Google-Smtp-Source: APXvYqzHHp6AEOybi8eSNzpS6yJenQVcFLfuQdedBvZo8EVVpn+IrB2YBO1WLPS/cnyQLb6Bv5XTSw==
X-Received: by 2002:a05:6214:4f0:: with SMTP id cl16mr3529738qvb.213.1578750004788;
        Sat, 11 Jan 2020 05:40:04 -0800 (PST)
Received: from [192.168.50.240] (c-73-94-106-141.hsd1.mn.comcast.net. [73.94.106.141])
        by smtp.gmail.com with ESMTPSA id x6sm2308285qkh.20.2020.01.11.05.39.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Jan 2020 05:40:04 -0800 (PST)
Subject: Re: crimson-osd vs legacy-osd: should the perf difference be already
 noticeable?
To:     "Liu, Chunmei" <chunmei.liu@intel.com>,
        Roman Penyaev <rpenyaev@suse.de>,
        kefu chai <tchaikov@gmail.com>,
        "Ma, Jianpeng" <jianpeng.ma@intel.com>
Cc:     Radoslaw Zarzynski <rzarzyns@redhat.com>,
        Samuel Just <sjust@redhat.com>,
        The Esoteric Order of the Squid Cybernetic 
        <ceph-devel@vger.kernel.org>
References: <02e2209f66f18217aa45b8f7caf715f6@suse.de>
 <CAJE9aON93O75PPRjfuFGYrtpBxRHHuepGX+tEC3FkBSgM6TgNQ@mail.gmail.com>
 <f3a976a6d2eba9cd8bd6bf46c0fc9967@suse.de>
 <BY5PR11MB4273BE8C4A3FB0E3D01A20ACE0380@BY5PR11MB4273.namprd11.prod.outlook.com>
From:   Mark Nelson <mark.a.nelson@gmail.com>
Message-ID: <7650fa23-d922-95b4-7a9b-3bdab331724e@gmail.com>
Date:   Sat, 11 Jan 2020 07:39:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <BY5PR11MB4273BE8C4A3FB0E3D01A20ACE0380@BY5PR11MB4273.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 1/10/20 5:28 PM, Liu, Chunmei wrote:
> 
> 
>> -----Original Message-----
>> From: ceph-devel-owner@vger.kernel.org <ceph-devel-owner@vger.kernel.org>
>> On Behalf Of Roman Penyaev
>> Sent: Friday, January 10, 2020 10:54 AM
>> To: kefu chai <tchaikov@gmail.com>
>> Cc: Radoslaw Zarzynski <rzarzyns@redhat.com>; Samuel Just
>> <sjust@redhat.com>; The Esoteric Order of the Squid Cybernetic <ceph-
>> devel@vger.kernel.org>
>> Subject: Re: crimson-osd vs legacy-osd: should the perf difference be already
>> noticeable?
>>
>> On 2020-01-10 17:18, kefu chai wrote:
>>
>> [skip]
>>
>>>>
>>>> First thing that catches my eye is that for small blocks there is no
>>>> big difference at all, but as the block increases, crimsons iops
>>>> starts to
>>>
>>> that's also our findings. and it's expected. as async messenger uses
>>> the same reactor model as seastar does. actually its original
>>> implementation was adapted from seastar's socket stream
>>> implementation.
>>
>> Hm, regardless of model messenger should not be a bottleneck.  Take a look on
>> the results of fio_ceph_messenger load (runs pure messenger), I can squeeze
>> IOPS=89.8k, BW=351MiB/s on 4k block size, iodepth=32.
>> (also good example https://github.com/ceph/ceph/pull/26932 , almost
>> ~200k)
>>
>> With PG layer (memstore_debug_omit_block_device_write=true option) I can
>> reach 40k iops max.  Without PG layer (immediate completion from the
>> transport callback, osd_immediate_completions=true) I get almost 60k.
>>
>> Seems that here starts playing costs on client side and these costs prevail.
>>
>>>
>>>> decline. Can it be the transport issue? Can be tested as well.
>>>
>>> because seastar's socket facility reads from the wire with 4K chunk
>>> size, while classic OSD's async messenger reads the payload with the
>>> size suggested by the header. so when it comes to larger block size,
>>> it takes crimson-osd multiple syscalls and memcpy calls to read the
>>> request from wire, that's why classic OSD wins in this case.
>>
>> Do you plan to fix that?
>>
>>> have you tried to use multiple fio clients to saturate CPU capacity of
>>> OSD nodes?
>>
>> Not yet.  But regarding CPU I have these numbers:
>>
>> output of pidstat while rbd.fio is running, 4k block only:
>>
>> legacy-osd
>>
>> [roman@dell ~]$ pidstat 1 -p 109930
>> Linux 5.3.13-arch1-1 (dell)     01/09/2020      _x86_64_        (8 CPU)
>>
>> 03:51:49 PM   UID       PID    %usr %system  %guest   %wait    %CPU
>> CPU  Command
>> 03:51:51 PM  1000    109930   14.00    8.00    0.00    0.00   22.00
>> 1  ceph-osd
>> 03:51:52 PM  1000    109930   40.00   19.00    0.00    0.00   59.00
>> 1  ceph-osd
>> 03:51:53 PM  1000    109930   44.00   17.00    0.00    0.00   61.00
>> 1  ceph-osd
>> 03:51:54 PM  1000    109930   40.00   20.00    0.00    0.00   60.00
>> 1  ceph-osd
>> 03:51:55 PM  1000    109930   39.00   18.00    0.00    0.00   57.00
>> 1  ceph-osd
>> 03:51:56 PM  1000    109930   41.00   20.00    0.00    0.00   61.00
>> 1  ceph-osd
>> 03:51:57 PM  1000    109930   41.00   15.00    0.00    0.00   56.00
>> 1  ceph-osd
>> 03:51:58 PM  1000    109930   42.00   16.00    0.00    0.00   58.00
>> 1  ceph-osd
>> 03:51:59 PM  1000    109930   42.00   15.00    0.00    0.00   57.00
>> 1  ceph-osd
>> 03:52:00 PM  1000    109930   43.00   15.00    0.00    0.00   58.00
>> 1  ceph-osd
>> 03:52:01 PM  1000    109930   24.00   12.00    0.00    0.00   36.00
>> 1  ceph-osd
>>
>>
>> crimson-osd
>>
>> [roman@dell ~]$ pidstat 1  -p 108141
>> Linux 5.3.13-arch1-1 (dell)     01/09/2020      _x86_64_        (8 CPU)
>>
>> 03:47:50 PM   UID       PID    %usr %system  %guest   %wait    %CPU
>> CPU  Command
>> 03:47:55 PM  1000    108141   67.00   11.00    0.00    0.00   78.00
>> 0  crimson-osd
>> 03:47:56 PM  1000    108141   79.00   12.00    0.00    0.00   91.00
>> 0  crimson-osd
>> 03:47:57 PM  1000    108141   81.00    9.00    0.00    0.00   90.00
>> 0  crimson-osd
>> 03:47:58 PM  1000    108141   78.00   12.00    0.00    0.00   90.00
>> 0  crimson-osd
>> 03:47:59 PM  1000    108141   78.00   12.00    0.00    1.00   90.00
>> 0  crimson-osd
>> 03:48:00 PM  1000    108141   78.00   13.00    0.00    0.00   91.00
>> 0  crimson-osd
>> 03:48:01 PM  1000    108141   79.00   13.00    0.00    0.00   92.00
>> 0  crimson-osd
>> 03:48:02 PM  1000    108141   78.00   12.00    0.00    0.00   90.00
>> 0  crimson-osd
>> 03:48:03 PM  1000    108141   77.00   11.00    0.00    0.00   88.00
>> 0  crimson-osd
>> 03:48:04 PM  1000    108141   79.00   12.00    0.00    1.00   91.00
>> 0  crimson-osd
>>
>>
>> Seems quite saturated, almost twice more than legacy-osd.  Did you see
>> something similar?
> Crimson-osd (seastar) use epoll, by default, it will use more cpu capacity,(you can change epoll mode setting to reduce it), add Ma, Jianpeng in the thread since he did more study on it.
> BTW, by default crimson-osd is one thread, and legacy ceph-osd (3 threads for async messenger, 2x8 threads for osd (SDD), finisher thread etc,) ,so by default setting, it is 1 thread compare to over 10 threads work,  it is expected crimson-osd not show obvious difference. you can change the default thread number for legacy ceph-osd(such as thread=1 for each layer to see more difference.)
> BTW, please use release build to do test.
> Crimson-osd is aysnc model, if workload is very light, can't take more advantage of it.
>>
>> --
>> Roman
> 

FWIW I can drive the classical OSD pretty hard and get around 70-80K 
IOPS out of a single OSD, but as Kefu says above it will consume a 
larger number of cores.  I do think per-OSD throughput is still 
important to look at, but the per-OSD efficiency numbers as Radek has 
been testing (I gathered some for classical OSD a while back for him) 
are probably going to be more important overall.

Mark
