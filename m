Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55324154FCE
	for <lists+ceph-devel@lfdr.de>; Fri,  7 Feb 2020 01:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgBGAiK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 6 Feb 2020 19:38:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59731 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726597AbgBGAiK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 6 Feb 2020 19:38:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581035889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WGWxCkishTCc/vZaMKKSK7JddDuBfSGm53sulHpza9U=;
        b=UfgjaSFeb+ET6JE4voz+7u4yoA7eYOTNjo2XI3cPw+ejMAtdjIhwrtJsmfpO/umYJbXgzm
        Iv88GEc4jq9sEQAu28zjm02SR+UslcMq07JSmVADN9zVaoM1bmZ6KlBGwEeEzVs2XUzBwa
        eIR9EPGzFUHDhQ//r/hw5WV/hYSq4Z4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-7q1B5-v3PGSAsI5vKWQpTQ-1; Thu, 06 Feb 2020 19:38:07 -0500
X-MC-Unique: 7q1B5-v3PGSAsI5vKWQpTQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 14F7814E0;
        Fri,  7 Feb 2020 00:38:06 +0000 (UTC)
Received: from [10.72.12.34] (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 30FD5790E4;
        Fri,  7 Feb 2020 00:38:00 +0000 (UTC)
Subject: Re: [PATCH resend v5 08/11] ceph: periodically send perf metrics to
 MDS
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20200129082715.5285-1-xiubli@redhat.com>
 <20200129082715.5285-9-xiubli@redhat.com>
 <57de3eb2f2009aec0ba086bb9d95a2936a7d1d9f.camel@kernel.org>
 <d4b8f9a5-b2f7-ec71-c8fe-528ec24d8695@redhat.com>
 <1cf98f0bd2bda7eef3f6b8f5bfd42188ee74ef38.camel@kernel.org>
 <6010186e-6b3d-8664-b4e9-b6a015b6cca2@redhat.com>
 <e78f9a17667240c8f0da02e3913444dec9e0911c.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <6c98cc89-a396-2047-b622-61442f2209f8@redhat.com>
Date:   Fri, 7 Feb 2020 08:37:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <e78f9a17667240c8f0da02e3913444dec9e0911c.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/6 23:21, Jeff Layton wrote:
> On Thu, 2020-02-06 at 20:26 +0800, Xiubo Li wrote:
>> On 2020/2/6 19:31, Jeff Layton wrote:
>>> On Thu, 2020-02-06 at 10:36 +0800, Xiubo Li wrote:
>>>> On 2020/2/6 5:43, Jeff Layton wrote:
>>>>> On Wed, 2020-01-29 at 03:27 -0500, xiubli@redhat.com wrote:
>>>> [...]
>>>>>> +
>>>>>> +static int sending_metrics_get(void *data, u64 *val)
>>>>>> +{
>>>>>> +	struct ceph_fs_client *fsc = (struct ceph_fs_client *)data;
>>>>>> +	struct ceph_mds_client *mdsc = fsc->mdsc;
>>>>>> +
>>>>>> +	mutex_lock(&mdsc->mutex);
>>>>>> +	*val = (u64)mdsc->sending_metrics;
>>>>>> +	mutex_unlock(&mdsc->mutex);
>>>>>> +
>>>>>> +	return 0;
>>>>>> +}
>>>>>> +DEFINE_SIMPLE_ATTRIBUTE(sending_metrics_fops, sending_metrics_get,
>>>>>> +			sending_metrics_set, "%llu\n");
>>>>>> +
>>>>> I'd like to hear more about how we expect users to use this facility.
>>>>> This debugfs file doesn't seem consistent with the rest of the UI, and I
>>>>> imagine if the box reboots you'd have to (manually) re-enable it after
>>>>> mount, right? Maybe this should be a mount option instead?
>>>> A mount option means we must do the unmounting to disable it.
>>>>
>>> Technically, no. You could wire it up so that you could enable and
>>> disable it via -o remount. For example:
>>>
>>>       # mount -o remount,metrics=disabled
>> Yeah, this is cool.
>>
>>> Another option might be a module parameter if this is something that you
>>> really want to be global (and not per-mount or per-session).
>>>
>>>> I was thinking with the debugfs file we can do the debug or tuning even
>>>> in the product setups at any time, usually this should be disabled since
>>>> it will send it per second.
>>>>
>>> Meh, one frame per second doesn't seem like it'll add much overhead.
>> Okay.
>>> Also, why one update per second? Should that interval be tunable?
>> Per second just keep it the same with the fuse client.
>>
> Ok.
>
>>>> Or we could merge the "sending_metric" to "metrics" UI, just writing
>>>> "enable"/"disable" to enable/disable sending the metrics to ceph, and
>>>> just like the "reset" does to clean the metrics.
>>>>
>>>> Then the "/sys/kernel/debug/ceph/XXX.clientYYY/metrics" could be
>>>> writable with:
>>>>
>>>> "reset"  --> to clean and reset the metrics counters
>>>>
>>>> "enable" --> enable sending metrics to ceph cluster
>>>>
>>>> "disable" --> disable sending metrics to ceph cluster
>>>>
>>>> Will this be better ?
>>>>
>>> I guess it's not clear to me how you intend for this to be used.
>>>
>>> A debugfs switch means that this is being enabled and disabled on a per-
>>> session basis. Is the user supposed to turn this on for all, or just one
>>> session? How do they know?
>> Not for all, just per-superblock.
>>
> If it's per-superblock, then a debugfs-based switch seems particularly
> ill-suited for this, as that's really a per-session interface.
>
>>> Is this something we expect people to just turn on briefly when they are
>>> experiencing a problem, or is this something that we expect to be turned
>>> on and left on for long periods of time?
>> If this won't add much overhead even per second, let's keep sending the
>> metrics to ceph always and the mount option for this switch is not
>> needed any more.
>>
> Note that I don't really _know_ that it won't be a problem, just that it
> doesn't sound too bad. I think we probably will want some mechanism to
> enable/disable this until we have some experience with it in the field.
>
>> And there is already a switch to enable/disable showing the metrics in
>> the ceph side, if here add another switch per client, it will be also
>> yucky for admins .
>>
>> Let's make the update interval tunable and per second as default. Maybe
>> we should make this as a global UI for all clients ?
>>
> If you want a global setting for the interval that would take effect on
> all ceph mounts, then maybe a "metric_send_interval" module parameter
> would be best. Make it an unsigned int, and allow the admin to set it to
> 0 to turn off stats transmission in the client.
>
> We have a well-defined interface for setting module parameters on most
> distros (via /etc/modprobe.d/), so that would be better than monkeying
> around with debugfs here, IMO.
>
> As to the default, it might be best to have this default to 0 initially.
> Once we have more experience with it we could make it default to 1 in a
> later release.

Yeah, this makes sense.

Let's switch to the module parameter "metric_send_interval", at the same 
time this will also act as a switch.

0 means off, >0 will be the interval.

Thanks,


