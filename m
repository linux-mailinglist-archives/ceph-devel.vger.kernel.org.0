Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0970F72F238
	for <lists+ceph-devel@lfdr.de>; Wed, 14 Jun 2023 03:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239348AbjFNBxw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 21:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237195AbjFNBxu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 21:53:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9953C1716
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jun 2023 18:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686707580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+iZswuipC7JgIu9I0HN+5r5X4bKAHRprWjVrwgN5sVg=;
        b=FJfFmKmWCsZYAOFbg1VlUD70jEkmiZXsmBqnBXkNGZL7sbSUYHchmvjnj1TnEc8LBjZhfA
        0akt6RCxpnIF3eJGpoV69W5WIAYh9mfecgbI+iji/In3H+uHrbLsAAYn31KViLsmm4uGDD
        Bsmw96CazHztlavROIJuIDlGZKzjNK8=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-480-EzEByAc3OFO4w6B2KohMeg-1; Tue, 13 Jun 2023 21:52:59 -0400
X-MC-Unique: EzEByAc3OFO4w6B2KohMeg-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-259a3c7fe26so2729646a91.1
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jun 2023 18:52:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686707578; x=1689299578;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+iZswuipC7JgIu9I0HN+5r5X4bKAHRprWjVrwgN5sVg=;
        b=WLwwu2o4nySr5tutSNcbKYmuYwOaYVc+p3Qv7HPNXGyIaVj1InaWzAH8+0zL8D4pDY
         j2xA2rDL5xw5SMMVpgAhMmdqJm7ubo6yrbp+Wdn+shDGAJGu+D/8vhi9ibdKBZqHZfoV
         Z99QxDc0pn6SuS4u6c8Z8YGzFwSOGjIVCEc0KxazwrCM2IZ1DdUwwb2Exw0uVO/bT6hu
         SS+m8lPTQ8UnGGPEGl6nQrYBZ+lBuo4YeX18wU9fRamj/GxprG+wkrn+P27SJo59tFHv
         D2RL80tHbhefgWYzEW5wQELm+53A5wR0RLYe6mCOOz1h7Io2/Tz26ijMUoIqhjV3bjrA
         IYfw==
X-Gm-Message-State: AC+VfDwDnrJ/Qydt3yjNdc8d8thC8B3j5tbpWHsyfUukSYiWo4E5OUR6
        /CBDpgJBEN0E8jNYl0uW0klS1k1xsLfm1DqNMausWcDMIByyGWF80+ejoQxfXaiQAceYkl5o+OI
        zgRsFiv67k74d4VSeFwoMClYliNFqZrwg
X-Received: by 2002:a05:6a20:12ca:b0:114:bbe5:baf4 with SMTP id v10-20020a056a2012ca00b00114bbe5baf4mr403778pzg.24.1686707577949;
        Tue, 13 Jun 2023 18:52:57 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7sCKCX4BLLpiiKABZgtjTIRM8CXrt20k7r8K6ci2cc7bb1n3KHu3zDLW8NzAYGhQmIl0yZbg==
X-Received: by 2002:a05:6a20:12ca:b0:114:bbe5:baf4 with SMTP id v10-20020a056a2012ca00b00114bbe5baf4mr403764pzg.24.1686707577513;
        Tue, 13 Jun 2023 18:52:57 -0700 (PDT)
Received: from [10.72.12.155] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u5-20020a170902e80500b001b02162c86bsm6470254plg.80.2023.06.13.18.52.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Jun 2023 18:52:56 -0700 (PDT)
Message-ID: <977d8133-a55f-0667-dc12-aa6fd7d8c3e4@redhat.com>
Date:   Wed, 14 Jun 2023 09:52:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v5 00/14] ceph: support idmapped mounts
Content-Language: en-US
To:     Gregory Farnum <gfarnum@redhat.com>,
        Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        Christian Brauner <brauner@kernel.org>
Cc:     stgraber@ubuntu.com, linux-fsdevel@vger.kernel.org,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230608154256.562906-1-aleksandr.mikhalitsyn@canonical.com>
 <f3864ed6-8c97-8a7a-f268-dab29eb2fb21@redhat.com>
 <CAEivzxcRsHveuW3nrPnSBK6_2-eT4XPvza3kN2oogvnbVXBKvQ@mail.gmail.com>
 <20230609-alufolie-gezaubert-f18ef17cda12@brauner>
 <CAEivzxc_LW6mTKjk46WivrisnnmVQs0UnRrh6p0KxhqyXrErBQ@mail.gmail.com>
 <ac1c6817-9838-fcf3-edc8-224ff85691e0@redhat.com>
 <CAJ4mKGby71qfb3gd696XH3AazeR0Qc_VGYupMznRH3Piky+VGA@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAJ4mKGby71qfb3gd696XH3AazeR0Qc_VGYupMznRH3Piky+VGA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/13/23 22:53, Gregory Farnum wrote:
> On Mon, Jun 12, 2023 at 6:43 PM Xiubo Li <xiubli@redhat.com> wrote:
>>
>> On 6/9/23 18:12, Aleksandr Mikhalitsyn wrote:
>>> On Fri, Jun 9, 2023 at 12:00 PM Christian Brauner <brauner@kernel.org> wrote:
>>>> On Fri, Jun 09, 2023 at 10:59:19AM +0200, Aleksandr Mikhalitsyn wrote:
>>>>> On Fri, Jun 9, 2023 at 3:57 AM Xiubo Li <xiubli@redhat.com> wrote:
>>>>>> On 6/8/23 23:42, Alexander Mikhalitsyn wrote:
>>>>>>> Dear friends,
>>>>>>>
>>>>>>> This patchset was originally developed by Christian Brauner but I'll continue
>>>>>>> to push it forward. Christian allowed me to do that :)
>>>>>>>
>>>>>>> This feature is already actively used/tested with LXD/LXC project.
>>>>>>>
>>>>>>> Git tree (based on https://github.com/ceph/ceph-client.git master):
>>>>> Hi Xiubo!
>>>>>
>>>>>> Could you rebase these patches to 'testing' branch ?
>>>>> Will do in -v6.
>>>>>
>>>>>> And you still have missed several places, for example the following cases:
>>>>>>
>>>>>>
>>>>>>       1    269  fs/ceph/addr.c <<ceph_netfs_issue_op_inline>>
>>>>>>                 req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR,
>>>>>> mode);
>>>>> +
>>>>>
>>>>>>       2    389  fs/ceph/dir.c <<ceph_readdir>>
>>>>>>                 req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
>>>>> +
>>>>>
>>>>>>       3    789  fs/ceph/dir.c <<ceph_lookup>>
>>>>>>                 req = ceph_mdsc_create_request(mdsc, op, USE_ANY_MDS);
>>>>> We don't have an idmapping passed to lookup from the VFS layer. As I
>>>>> mentioned before, it's just impossible now.
>>>> ->lookup() doesn't deal with idmappings and really can't otherwise you
>>>> risk ending up with inode aliasing which is really not something you
>>>> want. IOW, you can't fill in inode->i_{g,u}id based on a mount's
>>>> idmapping as inode->i_{g,u}id absolutely needs to be a filesystem wide
>>>> value. So better not even risk exposing the idmapping in there at all.
>>> Thanks for adding, Christian!
>>>
>>> I agree, every time when we use an idmapping we need to be careful with
>>> what we map. AFAIU, inode->i_{g,u}id should be based on the filesystem
>>> idmapping (not mount),
>>> but in this case, Xiubo want's current_fs{u,g}id to be mapped
>>> according to an idmapping.
>>> Anyway, it's impossible at now and IMHO, until we don't have any
>>> practical use case where
>>> UID/GID-based path restriction is used in combination with idmapped
>>> mounts it's not worth to
>>> make such big changes in the VFS layer.
>>>
>>> May be I'm not right, but it seems like UID/GID-based path restriction
>>> is not a widespread
>>> feature and I can hardly imagine it to be used with the container
>>> workloads (for instance),
>>> because it will require to always keep in sync MDS permissions
>>> configuration with the
>>> possible UID/GID ranges on the client. It looks like a nightmare for sysadmin.
>>> It is useful when cephfs is used as an external storage on the host, but if you
>>> share cephfs with a few containers with different user namespaces idmapping...
>> Hmm, while this will break the MDS permission check in cephfs then in
>> lookup case. If we really couldn't support it we should make it to
>> escape the check anyway or some OPs may fail and won't work as expected.
> I don't pretend to know the details of the VFS (or even our linux
> client implementation), but I'm confused that this is apparently so
> hard. It looks to me like we currently always fill in the "caller_uid"
> with "from_kuid(&init_user_ns, req->r_cred->fsuid))". Is this actually
> valid to begin with? If it is, why can't the uid mapping be applied on
> that?
>
> As both the client and the server share authority over the inode's
> state (including things like mode bits and owners), and need to do
> permission checking, being able to tell the server the relevant actor
> is inherently necessary. We also let admins restrict keys to
> particular UID/GID combinations as they wish, and it's not the most
> popular feature but it does get deployed. I would really expect a user
> of UID mapping to be one of the *most* likely to employ such a
> facility...maybe not with containers, but certainly end-user homedirs
> and shared spaces.
>
> Disabling the MDS auth checks is really not an option. I guess we
> could require any user employing idmapping to not be uid-restricted,
> and set the anonymous UID (does that work, Xiubo, or was it the broken
> one? In which case we'd have to default to root?). But that seems a
> bit janky to me.

Yeah, this also seems risky.

Instead disabling the MDS auth checks there is another option, which is 
we can prevent  the kclient to be mounted or the idmapping to be 
applied. But this still have issues, such as what if admins set the MDS 
auth caps after idmap applied to the kclients ?

IMO there have 2 options: the best way is to fix this in VFS if 
possible. Else to add one option to disable the corresponding MDS auth 
caps in ceph if users want to support the idmap feature.

Thanks

- Xiubo

> -Greg
>
>> @Greg
>>
>> For the lookup requests the idmapping couldn't get the mapped UID/GID
>> just like all the other requests, which is needed by the MDS permission
>> check. Is that okay to make it disable the check for this case ? I am
>> afraid this will break the MDS permssions logic.
>>
>> Any idea ?
>>
>> Thanks
>>
>> - Xiubo
>>
>>
>>> Kind regards,
>>> Alex
>>>

