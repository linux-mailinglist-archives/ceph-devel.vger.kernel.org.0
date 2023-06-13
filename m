Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7E8372D714
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 03:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238553AbjFMBoJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 12 Jun 2023 21:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238478AbjFMBoH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 12 Jun 2023 21:44:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C1BEC
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 18:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686620597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aO3YIuRj1v9NRDAnjivXdeLDCfNfrRHlbKdCGoRnb1g=;
        b=NO7LuVbelAxddmSWwYtO+hbT9DvHaG2hJIXPJ3pF69B8W6aaTtlF6eGURspVtbYT6uD2DP
        du7jVa9q419Swjf92sK12Jzd43P1YQ8KDxt6RS5uAqHV2AUghTqF79GXYQJrQq/dJ0ddn1
        jB2kGlvUT9+GfFHEHXyYPij6+TIthKk=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-108-zUvVP4FDO8u3qw-Auc2lDA-1; Mon, 12 Jun 2023 21:43:16 -0400
X-MC-Unique: zUvVP4FDO8u3qw-Auc2lDA-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1b3c7e6ea5bso10305035ad.2
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jun 2023 18:43:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686620595; x=1689212595;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aO3YIuRj1v9NRDAnjivXdeLDCfNfrRHlbKdCGoRnb1g=;
        b=D6A9z40bj2zqCXkqKF9Tch+CmvhKdDOGayaALDh3DQkp+DPJj9WUxhM6qIx4fPJZge
         3uvqHX2LGCx8jDWgwFyYKYLo4nDJe+VkpnW6rCQXBwpoF/iF3V1sUX2YLsBQGtf9yvI2
         wnSYTyNf3VwlstuehHUUSbxmWF8am+Eh+gg3dsQgkLocVMSdEClyTHE066h+haCcisaW
         XypKq/wT3AnEsgzBErE53gk43Rycdr7kA02nfpO5D6K/1v7VPAuHTAApW8NhpoMG2cmB
         pOJKrdICEQNSgbS9R61SoBhCz72c2cJzpq8EGQv3fvnxguZkKps31a92fyJxT3GmV4nx
         ntIA==
X-Gm-Message-State: AC+VfDyULh+Ai9MS0iXFFABRlXAadIuYkXIruYGnWPDoMuW9BeWiipZN
        M4OK1gI3OKpC6Rqdlzcgb9Y6Gq1ilwfKhwRHFH5bMkNyMk581odyIWRdsvdSd/eYbejbF4YRlPu
        UGi3cEeDtgrEoKIk+QkbQL8xZ6sWmsjz6
X-Received: by 2002:a17:902:9343:b0:1b3:e3a4:1512 with SMTP id g3-20020a170902934300b001b3e3a41512mr1331483plp.10.1686620594907;
        Mon, 12 Jun 2023 18:43:14 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4UqLaeJy8Dx4xPm8hKZz+Zddi8ZLB53ENnzz9yoPHTsJ5i0KKo8CQQ0pO75DTJjcpw527Yww==
X-Received: by 2002:a17:902:9343:b0:1b3:e3a4:1512 with SMTP id g3-20020a170902934300b001b3e3a41512mr1331473plp.10.1686620594604;
        Mon, 12 Jun 2023 18:43:14 -0700 (PDT)
Received: from [10.72.12.125] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id t14-20020a1709028c8e00b001aaed55aff3sm8810948plo.137.2023.06.12.18.43.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 18:43:14 -0700 (PDT)
Message-ID: <ac1c6817-9838-fcf3-edc8-224ff85691e0@redhat.com>
Date:   Tue, 13 Jun 2023 09:43:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v5 00/14] ceph: support idmapped mounts
Content-Language: en-US
To:     Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        Christian Brauner <brauner@kernel.org>,
        Gregory Farnum <gfarnum@redhat.com>
Cc:     stgraber@ubuntu.com, linux-fsdevel@vger.kernel.org,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230608154256.562906-1-aleksandr.mikhalitsyn@canonical.com>
 <f3864ed6-8c97-8a7a-f268-dab29eb2fb21@redhat.com>
 <CAEivzxcRsHveuW3nrPnSBK6_2-eT4XPvza3kN2oogvnbVXBKvQ@mail.gmail.com>
 <20230609-alufolie-gezaubert-f18ef17cda12@brauner>
 <CAEivzxc_LW6mTKjk46WivrisnnmVQs0UnRrh6p0KxhqyXrErBQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAEivzxc_LW6mTKjk46WivrisnnmVQs0UnRrh6p0KxhqyXrErBQ@mail.gmail.com>
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


On 6/9/23 18:12, Aleksandr Mikhalitsyn wrote:
> On Fri, Jun 9, 2023 at 12:00 PM Christian Brauner <brauner@kernel.org> wrote:
>> On Fri, Jun 09, 2023 at 10:59:19AM +0200, Aleksandr Mikhalitsyn wrote:
>>> On Fri, Jun 9, 2023 at 3:57 AM Xiubo Li <xiubli@redhat.com> wrote:
>>>>
>>>> On 6/8/23 23:42, Alexander Mikhalitsyn wrote:
>>>>> Dear friends,
>>>>>
>>>>> This patchset was originally developed by Christian Brauner but I'll continue
>>>>> to push it forward. Christian allowed me to do that :)
>>>>>
>>>>> This feature is already actively used/tested with LXD/LXC project.
>>>>>
>>>>> Git tree (based on https://github.com/ceph/ceph-client.git master):
>>> Hi Xiubo!
>>>
>>>> Could you rebase these patches to 'testing' branch ?
>>> Will do in -v6.
>>>
>>>> And you still have missed several places, for example the following cases:
>>>>
>>>>
>>>>      1    269  fs/ceph/addr.c <<ceph_netfs_issue_op_inline>>
>>>>                req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_GETATTR,
>>>> mode);
>>> +
>>>
>>>>      2    389  fs/ceph/dir.c <<ceph_readdir>>
>>>>                req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
>>> +
>>>
>>>>      3    789  fs/ceph/dir.c <<ceph_lookup>>
>>>>                req = ceph_mdsc_create_request(mdsc, op, USE_ANY_MDS);
>>> We don't have an idmapping passed to lookup from the VFS layer. As I
>>> mentioned before, it's just impossible now.
>> ->lookup() doesn't deal with idmappings and really can't otherwise you
>> risk ending up with inode aliasing which is really not something you
>> want. IOW, you can't fill in inode->i_{g,u}id based on a mount's
>> idmapping as inode->i_{g,u}id absolutely needs to be a filesystem wide
>> value. So better not even risk exposing the idmapping in there at all.
> Thanks for adding, Christian!
>
> I agree, every time when we use an idmapping we need to be careful with
> what we map. AFAIU, inode->i_{g,u}id should be based on the filesystem
> idmapping (not mount),
> but in this case, Xiubo want's current_fs{u,g}id to be mapped
> according to an idmapping.
> Anyway, it's impossible at now and IMHO, until we don't have any
> practical use case where
> UID/GID-based path restriction is used in combination with idmapped
> mounts it's not worth to
> make such big changes in the VFS layer.
>
> May be I'm not right, but it seems like UID/GID-based path restriction
> is not a widespread
> feature and I can hardly imagine it to be used with the container
> workloads (for instance),
> because it will require to always keep in sync MDS permissions
> configuration with the
> possible UID/GID ranges on the client. It looks like a nightmare for sysadmin.
> It is useful when cephfs is used as an external storage on the host, but if you
> share cephfs with a few containers with different user namespaces idmapping...

Hmm, while this will break the MDS permission check in cephfs then in 
lookup case. If we really couldn't support it we should make it to 
escape the check anyway or some OPs may fail and won't work as expected.

@Greg

For the lookup requests the idmapping couldn't get the mapped UID/GID 
just like all the other requests, which is needed by the MDS permission 
check. Is that okay to make it disable the check for this case ? I am 
afraid this will break the MDS permssions logic.

Any idea ?

Thanks

- Xiubo


> Kind regards,
> Alex
>

